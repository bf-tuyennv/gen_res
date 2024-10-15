import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

import '../models/pubspec.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import '../utils/string.dart';
import '../utils/list.dart';
import 'generator_helper.dart';

class DrawableGenerator {
  DrawableGenerator({
    required this.rootPath,
    required this.pubspec,
    required this.formatter,
  }) {
    path = pubspec.genRes.drawables.path;
  }
  final String rootPath;
  late final String path;
  final Pubspec pubspec;
  final DartFormatter formatter;

  String generate() {
    if (pubspec.genRes.drawables.path.isEmpty) {
      throw const InvalidSettingsException('Please add the path to Drawables resources');
    }
    if (!pubspec.flutter.assets.containPath(path)) {
      Logger.warning("""Please add the path $path into assets field like this in pubspec.yaml file
flutter:
  assets:
    - $path""");
    }
    final buffer = StringBuffer();

    buffer.writeln(header);
    buffer.writeln(ignoreAnalysis);
    buffer.writeln();
    buffer.writeln('class Drawables {');
    generateContent(buffer, path);
    buffer.writeln('}');

    return formatter.format(buffer.toString());
  }

  void generateContent(StringBuffer buffer, String path) {
    final Map<String, String> mapContent = <String, String>{};
    final fileList = Directory(path).listSync(recursive: true).whereType<File>();
    for (final file in fileList) {
      final String relativePath = relative(file.path, from: join(rootPath, path));
      String key = relativePath.snakeCaseFile(withExtension: false);
      final String value = relativePath.snakeCaseFile();
      if (mapContent.containsKey(key)) {
        throw Duplicated('Duplicated file name ${mapContent[key]} and $value');
      }
      mapContent[key] = value;
    }
    mapContent.forEach((key, value) {
      buffer.writeln('String get $key => \'$path$value\';');
    });
  }
}
