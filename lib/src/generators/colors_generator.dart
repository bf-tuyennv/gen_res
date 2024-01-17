import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';

import '../models/gen_res_color.dart';
import '../utils/color.dart';
import '../utils/error.dart';
import 'generator_helper.dart';

class ColorGenerator {
  ColorGenerator({
    required this.pubspecFile,
    required this.formatter,
    required this.colors,
  });
  final File pubspecFile;
  final DartFormatter formatter;
  final GenResColor colors;

  Future<String> generate() async {
    if (colors.path.isEmpty) {
      throw const InvalidSettingsException('The value of "flutter_gen/colors:" is incorrect.');
    }
    if (!await File(colors.path).exists()) {
      throw const InvalidSettingsException('Please create assets/colors/colors.xml to define colors.');
    }

    final buffer = StringBuffer();
    buffer.writeln(header);
    buffer.writeln(ignoreAnalysis);
    buffer.writeln("import 'package:flutter/painting.dart';");
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln();
    buffer.writeln('class Colors {');
    buffer.writeln();

    final colorList = <_Color>[];

    final ColorPath colorFile = ColorPath(join(pubspecFile.parent.path, colors.path));

    final data = colorFile.file.readAsStringSync();
    if (colorFile.isXml) {
      colorList.addAll(XmlDocument.parse(data).findAllElements('color').map((element) {
        return _Color.fromXmlElement(element);
      }));
    } else {
      throw 'Not supported file type ${colorFile.mime}.';
    }

    colorList
        .distinctBy((color) => color.name)
        .sortedBy((color) => color.name)
        .map(_colorStatement)
        .forEach(buffer.write);

    buffer.writeln('}');
    return formatter.format(buffer.toString());
  }

  String _colorStatement(_Color color) {
    final buffer = StringBuffer();
    if (color.isMaterial) {
      final swatch = ColorUtils.swatchFromPrimaryHex(color.hex);
      final statement = '''/// MaterialColor: 
        ${swatch.entries.map((e) => '///   ${e.key}: ${ColorUtils.hexFromColor(e.value)}').join('\n')}
        MaterialColor get ${color.name} => const MaterialColor(
    ${swatch[500]},
    <int, Color>{
      ${swatch.entries.map((e) => '${e.key}: Color(${e.value}),').join('\n')}
    },
  );''';
      buffer.writeln(statement);
    }
    if (color.isMaterialAccent) {
      final accentSwatch = ColorUtils.accentSwatchFromPrimaryHex(color.hex);
      final statement = '''/// MaterialAccentColor: 
        ${accentSwatch.entries.map((e) => '///   ${e.key}: ${ColorUtils.hexFromColor(e.value)}').join('\n')}
        MaterialAccentColor get ${color.name}Accent => const MaterialAccentColor(
   ${accentSwatch[200]},
   <int, Color>{
     ${accentSwatch.entries.map((e) => '${e.key}: Color(${e.value}),').join('\n')}
    },
  );''';
      buffer.writeln(statement);
    }
    if (color.isNormal) {
      final comment = '/// Color: ${color.hex}';
      final statement = '''Color get ${color.name} => const Color(${ColorUtils.colorFromHex(color.hex)});''';

      buffer.writeln(comment);
      buffer.writeln(statement);
    }
    return buffer.toString();
  }
}

class _Color {
  const _Color(
    this.name,
    this.hex,
    this._types,
  );

  _Color.fromXmlElement(XmlElement element)
      : this(
          element.getAttribute('name')!,
          element.innerText,
          element.getAttribute('type')?.split(' ') ?? List.empty(),
        );

  final String name;

  final String hex;

  final List<String> _types;

  bool get isNormal => _types.isEmpty;

  bool get isMaterial => _types.contains('material');

  bool get isMaterialAccent => _types.contains('material-accent');
}
