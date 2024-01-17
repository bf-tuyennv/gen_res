import 'dart:io';

import 'package:dart_style/dart_style.dart';
import '../models/pubspec.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import 'generator_helper.dart';

class StringGenerator {
  StringGenerator({
    required this.pubspec,
    required this.formatter,
  });
  final Pubspec pubspec;
  final DartFormatter formatter;

  Future<String> generate() async {
    if (!pubspec.flutter.assets.contains(pubspec.genRes.strings.path)) {
      Logger.warning(
          """Please add the path ${pubspec.genRes.strings.path} into assets field like this in pubspec.yaml file
flutter:
  assets:
    - ${pubspec.genRes.strings.path}""");
    }

    final List<String> lines = await File(pubspec.genRes.strings.path).readAsLines();
    if (lines.isEmpty) {
      throw const InvalidSettingsException('The value of "flutter/strings:" is incorrect.');
    }

    final buffer = StringBuffer();
    buffer.writeln(header);
    buffer.writeln(ignoreAnalysis);
    buffer.writeln("\nimport 'package:easy_localization/easy_localization.dart';\n");
    buffer.writeln('class Strings {');

    lines.removeAt(0);

    for (final String line in lines) {
      buffer.writeln(_genLine(line));
    }

    buffer.writeln('}');
    return formatter.format(buffer.toString());
  }

  String _genLine(String line) {
    final List<String> values = line.split(',');
    final String key = values.first;
    values.removeAt(0);

    bool hasArgument = false;
    bool hasNamedArgument = false;

    for (String value in values) {
      hasArgument = _hasArgument(value) || hasArgument;
      hasNamedArgument = _hasNamedArgument(value) || hasNamedArgument;
      if (hasArgument && hasNamedArgument) {
        return '///$line\nString $key({List<String>? args, Map<String, String>? namedArgs}) => \'$key\'.tr(args: args, namedArgs: namedArgs);';
      }
    }
    
    if (hasArgument) return '///$line\nString $key({List<String>? args}) => \'$key\'.tr(args: args);';
    if (hasNamedArgument) return '///$line\nString $key({Map<String, String>? namedArgs}) => \'$key\'.tr(namedArgs: namedArgs);';

    return '///$line\nString get $key => \'$key\'.tr();';
  }

  bool _hasArgument(String value) => '{}'.allMatches(value).isNotEmpty;

  bool _hasNamedArgument(String value) {
    if (value.isEmpty) return false;
    int currentIndex = value.indexOf('{', 0);
    while (currentIndex < value.length && currentIndex != -1) {
      final int matchingIndex = value.indexOf('}', currentIndex);
      if (matchingIndex == -1) {
        currentIndex = value.indexOf('{', currentIndex + 1);
        continue;
      }
      final String key = value.substring(currentIndex + 1, matchingIndex);
      if (key.isEmpty) {
        currentIndex = value.indexOf('{', currentIndex + 1);
        continue;
      }
      return true;
    }
    return false;
  }
}
