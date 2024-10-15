// ignore_for_file: prefer_const_constructors

import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';

import '../models/flutter_font.dart';
import '../utils/error.dart';
import '../utils/string.dart';
import 'generator_helper.dart';

class FontGenerator {
  FontGenerator({
    required this.formatter,
    required this.fonts,
  });
  final DartFormatter formatter;
  final List<FlutterFont> fonts;
  String generate() {
    if (fonts.isEmpty) {
      throw InvalidSettingsException('The value of "flutter/fonts:" is incorrect.');
    }

    final buffer = StringBuffer();
    buffer.writeln(header);
    buffer.writeln(ignoreAnalysis);
    buffer.writeln('class AppFonts {');
    buffer.writeln();

    fonts.map((element) => element.family).distinct().sorted().forEach((family) {
      buffer.writeln("""/// Font family: $family
    String get ${family.snakeCase()} => '$family';""");
    });

    buffer.writeln('}');
    return formatter.format(buffer.toString());
  }
}
