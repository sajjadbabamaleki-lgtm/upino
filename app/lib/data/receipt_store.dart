/// Receipt photographs, kept in the app's own directory.
///
/// The picked file lives in a cache the system is free to clear, so it is
/// copied somewhere durable before its name is written into the plan. A plan
/// that points at a photograph that is no longer there is a record with a
/// hole in it, which is the one thing §21 does not allow.
library;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ReceiptStore {
  const ReceiptStore();

  static const _folder = 'receipts';

  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/$_folder');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// Opens the camera or the photo library and returns the stored filename,
  /// or null if the user backed out. The name is relative, so the plan
  /// survives the app's directory moving between installs.
  Future<String?> capture({required ImageSource source}) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      // A receipt only has to be readable. Full-resolution photographs make
      // the stored plan large for no gain.
      maxWidth: 1600,
      imageQuality: 80,
    );
    if (picked == null) return null;

    final dir = await _dir();
    final name = 'r${DateTime.now().microsecondsSinceEpoch}'
        '${_extensionOf(picked.name)}';
    await File(picked.path).copy('${dir.path}/$name');
    return name;
  }

  Future<File?> file(String name) async {
    final f = File('${(await _dir()).path}/$name');
    return f.existsSync() ? f : null;
  }

  static String _extensionOf(String name) {
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? '.jpg' : name.substring(dot).toLowerCase();
  }
}
