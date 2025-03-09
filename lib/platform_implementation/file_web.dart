// file_web.dart (Web)
class FileHelper {
  static Future<bool> fileExists(String path) async {
    return false; // Web does not have local file access
  }
}

class FileManager {
  static Future<String> readFile(String path) async {
    return "File reading is not supported on web";
  }
}
