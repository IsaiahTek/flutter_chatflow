/// file_web.dart (Web)
class FileHelper {
  /// always false because web doesn't have access to local files
  static Future<bool> fileExists(String path) async {
    return false; // Web does not have local file access
  }
}

/// FileManger wrapper for web
class FileManager {
  /// Web can't read local files
  static Future<String> readFile(String path) async {
    return "File reading is not supported on web";
  }
}
