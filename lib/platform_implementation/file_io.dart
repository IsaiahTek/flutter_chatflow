// file_io.dart (Non-Web)
import 'dart:io';

/// Standard Native Platform File helper
class FileHelper {

  /// wrapper for native file.exists
  static Future<bool> fileExists(String path) async {
    return File(path).exists();
  }
}

/// File manager for native File API
class FileManager {

  /// returns File of the platform
  static File readFile(String path) {
    return File(path);
  }
}

