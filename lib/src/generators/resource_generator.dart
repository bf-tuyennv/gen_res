import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'generator_helper.dart';

class ResourceGenerator {
  ResourceGenerator({
    required this.pubspecFile,
    required this.formatter,
    this.drawablesName,
    this.stringsName,
    this.colorsName,
    this.fontsName,
  });
  final File pubspecFile;
  final DartFormatter formatter;
  final String? drawablesName;
  final String? stringsName;
  final String? colorsName;
  final String? fontsName;

  String generate() {
    final buffer = StringBuffer();
    buffer.writeln(header);
    buffer.writeln(ignoreAnalysis);
    buffer.writeln();
    if (drawablesName != null) buffer.writeln('import \'$drawablesName\';');
    if (stringsName != null) buffer.writeln('import \'$stringsName\';');
    if (colorsName != null) buffer.writeln('import \'$colorsName\';');
    if (fontsName != null) buffer.writeln('import \'$fontsName\';');
    buffer.writeln();
    buffer.writeln('class R {');
    buffer.writeln('R._();');
    buffer.writeln();
    if (drawablesName != null) buffer.writeln('static final drawable = AppImages();');
    if (stringsName != null) buffer.writeln('static final string = AppLabels();');
    if (colorsName != null) buffer.writeln('static final color = Colors();');
    if (fontsName != null) buffer.writeln('static final font = Fonts();');
    // buffer.writeln('//static final dimen = Dimens();');

    buffer.writeln('}');
    return formatter.format(buffer.toString());
  }
}
