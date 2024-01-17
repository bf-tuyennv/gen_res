import 'dart:io';

class FileUtils {
  static void writeAsString(String text, {required File file}) {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(text);
  }
}
