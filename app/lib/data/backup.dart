/// A backup of the plan: the same document the app saves, sealed with a
/// password so it can sit in a chat, a cloud drive or an email without
/// becoming a readable record of someone's money.
///
/// The plan lives only on the phone. Without this, losing the phone or
/// reinstalling the app loses every entry, and the app itself has no server
/// to keep a copy on — which is the point of it.
///
/// Sealing is AES-256-GCM under a key stretched from the password with
/// PBKDF2-HMAC-SHA256. GCM authenticates as well as encrypts, so a wrong
/// password or a damaged file is refused rather than decrypted into
/// nonsense. Nothing about the password is stored anywhere.
library;

import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'plan_document.dart';

class BackupFailure implements Exception {
  const BackupFailure(this.kind);
  final BackupFailureKind kind;

  @override
  String toString() => 'BackupFailure: ${kind.name}';
}

enum BackupFailureKind {
  /// Not an Upino backup at all, or one from a newer format.
  notABackup,

  /// The password did not open it, or the file was altered.
  wrongPassword,

  /// It opened, but the plan inside is not one this build can read.
  unreadablePlan,
}

const _format = 'upino-backup';
const _version = 1;

/// Stretching cost. High enough that guessing passwords against a stolen
/// file is slow, low enough that sealing takes about a second on a phone.
const defaultBackupIterations = 120000;

/// The file extension a backup is saved with.
const backupExtension = 'upino';

final _cipher = AesGcm.with256bits();

Future<SecretKey> _key(String password, List<int> salt, int iterations) =>
    Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: 256,
    ).deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

/// The document, sealed. [iterations] is only lowered by tests.
Future<String> sealBackup(
  PlanDocument document,
  String password, {
  int iterations = defaultBackupIterations,
}) async {
  final salt = SecretKeyData.random(length: 16).bytes;
  final key = await _key(password, salt, iterations);
  final box = await _cipher.encrypt(
    utf8.encode(document.encode()),
    secretKey: key,
  );
  return const JsonEncoder.withIndent('  ').convert({
    'format': _format,
    'version': _version,
    'kdf': 'pbkdf2-hmac-sha256',
    'iterations': iterations,
    'salt': base64Encode(salt),
    'nonce': base64Encode(box.nonce),
    'cipher': 'aes-256-gcm',
    'data': base64Encode(box.cipherText),
    'mac': base64Encode(box.mac.bytes),
  });
}

/// The document inside a backup, or a [BackupFailure] saying why not.
Future<PlanDocument> openBackup(String text, String password) async {
  final Map<String, Object?> outer;
  final List<int> salt, nonce, data, mac;
  final int iterations;
  try {
    outer = Map<String, Object?>.from(jsonDecode(text) as Map);
    if (outer['format'] != _format || outer['version'] != _version) {
      throw const FormatException();
    }
    iterations = outer['iterations']! as int;
    salt = base64Decode(outer['salt']! as String);
    nonce = base64Decode(outer['nonce']! as String);
    data = base64Decode(outer['data']! as String);
    mac = base64Decode(outer['mac']! as String);
  } on Object {
    throw const BackupFailure(BackupFailureKind.notABackup);
  }

  final List<int> clear;
  try {
    clear = await _cipher.decrypt(
      SecretBox(data, nonce: nonce, mac: Mac(mac)),
      secretKey: await _key(password, salt, iterations),
    );
  } on SecretBoxAuthenticationError {
    throw const BackupFailure(BackupFailureKind.wrongPassword);
  }

  try {
    return PlanDocument.decode(utf8.decode(clear));
  } on Object {
    throw const BackupFailure(BackupFailureKind.unreadablePlan);
  }
}
