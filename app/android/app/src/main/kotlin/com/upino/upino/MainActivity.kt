package com.upino.upino

import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "upino/sms")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "inbox" -> {
                        val since = (call.argument<Number>("since") ?: 0).toLong()
                        result.success(readInbox(since))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Messages received after [since] (epoch milliseconds), newest last. Read
     * on the phone and handed to Dart, which keeps only what looks like a
     * bank's debit notice. Nothing leaves the device.
     */
    private fun readInbox(since: Long): List<Map<String, Any?>> {
        if (checkSelfPermission(Manifest.permission.READ_SMS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return emptyList()
        }
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
}
