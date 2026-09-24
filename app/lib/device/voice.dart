/// Speech to text for Quick Expense, through the phone's own recogniser.
///
/// Android's recogniser decides where the audio goes: offline where the
/// phone has the language pack, otherwise the phone's speech service, which
/// on many phones is Google's. The sheet says so under the result.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Why nothing usable came back, so the sheet can say something more useful
/// than silence.
enum VoiceFailure {
  /// The phone has no speech recogniser the app can use.
  unavailable,

  /// The microphone was not allowed.
  noPermission,

  /// The recogniser needs the internet and could not reach it.
  network,

  /// It listened and heard nothing it could turn into words.
  nothingHeard,
}

class VoiceResult {
  const VoiceResult.heard(String this.text) : failure = null;
  const VoiceResult.failed(VoiceFailure this.failure) : text = null;

  final String? text;
  final VoiceFailure? failure;
}

abstract class VoiceInput {
  /// Null where there is no microphone path, which includes every test.
  static VoiceInput? instance;

  /// Listens once. [onPartial] follows the words as they are recognised so
  /// the person can see they are being heard.
  Future<VoiceResult> listen({
    required String localeId,
    ValueChanged<String>? onPartial,
  });

  Future<void> stop();
}

class SpeechVoiceInput implements VoiceInput {
  final _speech = SpeechToText();
  bool _ready = false;
  Completer<VoiceResult>? _done;
  String _last = '';
  VoiceFailure? _failure;
  ValueChanged<String>? _onPartial;

  Future<bool> _init() async {
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        onStatus: (status) {
          if (status == SpeechToText.doneStatus ||
              status == SpeechToText.notListeningStatus) {
            _finish();
          }
        },
        onError: _onError,
      );
    } on Object catch (error) {
      debugPrint('Speech not initialised: $error');
      _ready = false;
    }
    return _ready;
  }

  void _onError(SpeechRecognitionError error) {
    final code = error.errorMsg;
    _failure = switch (code) {
      'error_network' ||
      'error_network_timeout' ||
      'error_server' ||
      'error_server_disconnected' =>
        VoiceFailure.network,
      'error_permission' ||
      'error_insufficient_permissions' =>
        VoiceFailure.noPermission,
      'error_language_not_supported' ||
      'error_language_unavailable' ||
      'error_recognizer_busy' ||
      'error_client' =>
        VoiceFailure.unavailable,
      _ => VoiceFailure.nothingHeard,
    };
    _finish();
  }

  void _finish() {
    final done = _done;
    if (done == null || done.isCompleted) return;
    final text = _last.trim();
    done.complete(
      text.isNotEmpty
          ? VoiceResult.heard(text)
          : VoiceResult.failed(_failure ?? VoiceFailure.nothingHeard),
    );
  }

  static const _system = MethodChannel('upino/voice');

  /// The phone's own speech screen. Many phones (Xiaomi's among them) keep
  /// a recogniser other apps cannot drive directly but still open this
  /// screen, which records with its own permission.
  Future<VoiceResult> _systemScreen(String localeId, VoiceFailure why) async {
    try {
      final words = await _system.invokeMethod<String>('recognize', {
        'locale': localeId.replaceAll('_', '-'),
      });
      final text = words?.trim() ?? '';
      return text.isEmpty
          ? const VoiceResult.failed(VoiceFailure.nothingHeard)
          : VoiceResult.heard(text);
    } on Object catch (error) {
      debugPrint('No speech screen: $error');
      return VoiceResult.failed(why);
    }
  }

  @override
  Future<VoiceResult> listen({
    required String localeId,
    ValueChanged<String>? onPartial,
  }) async {
    final direct = await _listenDirect(localeId, onPartial);
    return switch (direct.failure) {
      VoiceFailure.unavailable ||
      VoiceFailure.network =>
        _systemScreen(localeId, direct.failure!),
      _ => direct,
    };
  }

  Future<VoiceResult> _listenDirect(
    String localeId,
    ValueChanged<String>? onPartial,
  ) async {
    if (!await _init()) {
      final allowed = await _speech.hasPermission;
      return VoiceResult.failed(
        allowed ? VoiceFailure.unavailable : VoiceFailure.noPermission,
      );
    }
    _done = Completer<VoiceResult>();
    _last = '';
    _failure = null;
    _onPartial = onPartial;
    try {
      await _speech.listen(
        onResult: (result) {
          _last = result.recognizedWords;
          _onPartial?.call(_last);
          if (result.finalResult) _finish();
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          cancelOnError: true,
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 3),
        ),
      );
    } on Object catch (error) {
      debugPrint('Speech not started: $error');
      _failure = VoiceFailure.unavailable;
      _finish();
    }
    return _done!.future;
  }

  @override
  Future<void> stop() async {
    await _speech.stop();
    _finish();
  }
}
