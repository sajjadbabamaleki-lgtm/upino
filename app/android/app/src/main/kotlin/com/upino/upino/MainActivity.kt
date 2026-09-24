package com.upino.upino

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.speech.RecognizerIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingSmsPermission: MethodChannel.Result? = null
    private var pendingSpeech: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "upino/sms")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "inbox" -> {
                        val since = (call.argument<Number>("since") ?: 0).toLong()
                        result.success(readInbox(since))
                    }
                    "requestPermission" -> requestSmsPermission(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "upino/voice")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "recognize" -> recognize(
                        call.argument<String>("locale"),
                        call.argument<String>("prompt"),
                        result,
                    )
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * The phone's own speech screen, for phones whose recogniser will not
     * take requests from other apps directly. It records with its own
     * microphone permission and hands back the words, or null.
     */
    private fun recognize(locale: String?, prompt: String?, result: MethodChannel.Result) {
        pendingSpeech?.success(null)
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(
                RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM,
            )
            if (locale != null) putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale)
            if (prompt != null) putExtra(RecognizerIntent.EXTRA_PROMPT, prompt)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
        }
        try {
            pendingSpeech = result
            startActivityForResult(intent, SPEECH_REQUEST)
        } catch (error: ActivityNotFoundException) {
            pendingSpeech = null
            result.error("unavailable", error.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != SPEECH_REQUEST) return
        val words = if (resultCode == Activity.RESULT_OK) {
            data?.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)?.firstOrNull()
        } else {
            null
        }
        pendingSpeech?.success(words)
        pendingSpeech = null
    }

    private fun hasSmsPermission() =
        checkSelfPermission(Manifest.permission.READ_SMS) ==
            PackageManager.PERMISSION_GRANTED

    /** Asks once, and answers Dart with whether reading is now allowed. */
    private fun requestSmsPermission(result: MethodChannel.Result) {
        if (hasSmsPermission()) {
            result.success(true)
            return
        }
        pendingSmsPermission?.success(false)
        pendingSmsPermission = result
        requestPermissions(arrayOf(Manifest.permission.READ_SMS), SMS_REQUEST)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != SMS_REQUEST) return
        val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        pendingSmsPermission?.success(granted)
        pendingSmsPermission = null
    }

    /**
     * Messages received after [since] (epoch milliseconds), newest last. Read
     * on the phone and handed to Dart, which keeps only what looks like a
     * bank's debit notice. Nothing leaves the device.
     */
    private fun readInbox(since: Long): List<Map<String, Any?>> {
        if (!hasSmsPermission()) return emptyList()
        val out = mutableListOf<Map<String, Any?>>()
        contentResolver.query(
            Uri.parse("content://sms/inbox"),
            arrayOf("_id", "address", "body", "date"),
            "date > ?",
            arrayOf(since.toString()),
            "date ASC",
        )?.use { cursor ->
            val id = cursor.getColumnIndexOrThrow("_id")
            val address = cursor.getColumnIndexOrThrow("address")
            val body = cursor.getColumnIndexOrThrow("body")
            val date = cursor.getColumnIndexOrThrow("date")
            // A bounded read: a first scan on a phone with years of messages
            // should not stall the app.
            while (cursor.moveToNext() && out.size < 500) {
                out.add(
                    mapOf(
                        "id" to cursor.getLong(id).toString(),
                        "address" to cursor.getString(address),
                        "body" to cursor.getString(body),
                        "date" to cursor.getLong(date),
                    ),
                )
            }
        }
        return out
    }

    private companion object {
        const val SMS_REQUEST = 4201
        const val SPEECH_REQUEST = 4202
    }
}
