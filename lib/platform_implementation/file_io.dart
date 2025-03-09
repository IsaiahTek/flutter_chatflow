// file_io.dart (Non-Web)
import 'dart:io';

/// Standard Native Platform File helper
class FileHelper {
  static Future<bool> fileExists(String path) async {
    return File(path).exists();
  }
}

class FileManager {
  static File readFile(String path) {
    return File(path);
  }
}

