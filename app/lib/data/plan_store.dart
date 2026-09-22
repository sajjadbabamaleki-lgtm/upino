/// Where the plan document lives.
///
/// The interface is deliberately a pair of string operations: everything that
/// can go wrong in persistence lives in the serialization, which is pure and
/// fully tested, rather than in the backend.
library;

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'plan_document.dart';

abstract class PlanStore {
  Future<PlanDocument?> load();
  Future<void> save(PlanDocument document);
  Future<void> clear();
}

/// Used by tests and by the first run before a file exists.
class InMemoryPlanStore implements PlanStore {
  InMemoryPlanStore([this._raw]);

  String? _raw;

  /// What is on "disk", so a test can assert the written form directly.
  String? get raw => _raw;

  @override
  Future<PlanDocument?> load() async =>
      _raw == null ? null : PlanDocument.decode(_raw!);

  @override
  Future<void> save(PlanDocument document) async => _raw = document.encode();

  @override
  Future<void> clear() async => _raw = null;
}

/// Writes to a file, replacing it atomically: the document is written beside
/// the target and renamed over it, so an interrupted write cannot leave a
/// half-saved plan behind.
///
/// Writes are serialized and coalesced. The app persists after every
/// mutation, so two rapid edits would otherwise race the same scratch path
/// and one rename would fail with the file already gone. While a write is in
/// flight the newest document replaces any queued one: an older state must
/// never land on disk after a newer one.
class FilePlanStore implements PlanStore {
  FilePlanStore(this.file);

  final File file;

  Future<void>? _draining;
  PlanDocument? _queued;

  static Future<FilePlanStore> inAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return FilePlanStore(File('${directory.path}/upino-plan.json'));
  }

  @override
  Future<PlanDocument?> load() async {
    if (!file.existsSync()) return null;
    return PlanDocument.decode(await file.readAsString());
  }

  @override
  Future<void> save(PlanDocument document) {
    _queued = document;
    return _draining ??= _drain();
  }

  Future<void> _drain() async {
    try {
      while (_queued != null) {
        final document = _queued!;
        _queued = null;
        await _writeAtomically(document);
      }
    } finally {
      _draining = null;
    }
  }

  Future<void> _writeAtomically(PlanDocument document) async {
    final temporary = File('${file.path}.writing');
    await temporary.writeAsString(document.encode(), flush: true);
    await temporary.rename(file.path);
  }

  @override
  Future<void> clear() async {
    await _draining;
    if (file.existsSync()) await file.delete();
  }
}
