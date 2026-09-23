/// Speech to text for Quick Expense, through the phone's own recogniser.
///
/// On-device recognition is asked for first, so on a phone with the offline
/// language pack nothing leaves the phone. Where there is none, Android's
/// recogniser is used as the phone provides it, which on many phones means
/// Google's service; the sheet says so next to the microphone.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class VoiceInput {
  /// Null where there is no microphone path, which includes every test.
  static VoiceInput? instance;

  /// What was said, or null if nothing was heard. [onPartial] follows the
  /// words as they are recognised so the person sees they are being heard.
  Future<String?> listen({
    required String localeId,
    ValueChanged<String>? onPartial,
  });

  Future<void> stop();
}

class SpeechVoiceInput implements VoiceInput {
  final _speech = SpeechToText();
  bool _ready = false;
  Completer<String?>? _done;
  String _last = '';

  Future<bool> _init() async {
    if (_ready) return true;
    _ready = await _speech.initialize(
      onStatus: (status) {
        if (status == SpeechToText.doneStatus ||
            status == SpeechToText.notListeningStatus) {
          _finish();
        }
      },
      onError: _onError,
    );
    return _ready;
  }

  bool _retryOnline = false;
  String? _localeId;
  ValueChanged<String>? _onPartial;

  void _onError(SpeechRecognitionError error) {
    // No offline model for this language: try once more the ordinary way.
    if (!_retryOnline && _localeId != null) {
      _retryOnline = true;
      unawaited(_start(onDevice: false));
      return;
    }
    _finish();
  }

  void _finish() {
    final done = _done;
    if (done == null || done.isCompleted) return;
    done.complete(_last.trim().isEmpty ? null : _last.trim());
  }

  Future<void> _start({required bool onDevice}) => _speech.listen(
        onResult: (result) {
          _last = result.recognizedWords;
          _onPartial?.call(_last);
          if (result.finalResult) _finish();
        },
        listenOptions: SpeechListenOptions(
          localeId: _localeId,
          onDevice: onDevice,
          partialResults: true,
          cancelOnError: true,
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 3),
        ),
      );

  @override
  Future<String?> listen({
    required String localeId,
    ValueChanged<String>? onPartial,
  }) async {
    if (!await _init()) return null;
    _done = Completer<String?>();
    _last = '';
    _retryOnline = false;
    _localeId = localeId;
    _onPartial = onPartial;
    await _start(onDevice: true);
    return _done!.future;
  }

  @override
  Future<void> stop() async {
    await _speech.stop();
    _finish();
  }
}
