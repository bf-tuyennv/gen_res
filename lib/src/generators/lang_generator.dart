import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../models/pubspec.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import 'package:csv/csv_settings_autodetection.dart';

class LangGenerator {
  LangGenerator({required this.pubspec});

  static const csvSettingsDetector =
      FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

  final Pubspec pubspec;
  final Map<String, String> result = {};
  final List<String> langs = [];
  final List<String> keys = [];
  final Map<String, Map<String, String>> langMap = {};

  Future<String> generate() async {
    final buffer = StringBuffer();
    _validateSettings();
    _loadSupportedLangs();
    _checkAssetsPath();

    final translationContent = await _readTranslationFile();
    final lines = _parseCsvContent(translationContent);
    _parseExistedLangs(lines);
    buffer.writeln(lines.first.join(','));

    _parseFromExtendedFile();

    for (final line in result.values) {
      buffer.writeln(line);
    }

    return buffer.toString();
  }

  void _validateSettings() {
    if (pubspec.genRes.strings.xlsxPath?.isEmpty ?? true) {
      throw const InvalidSettingsException(
          'The value of "xlsx_path:" is incorrect.');
    }
    if (pubspec.genRes.strings.supportedLangs?.isEmpty ?? true) {
      throw const InvalidSettingsException(
          'The value of "supported_langs:" is incorrect.');
    }
  }

  void _loadSupportedLangs() {
    langs.addAll(pubspec.genRes.strings.supportedLangs ?? []);
  }

  void _checkAssetsPath() {
    if (!pubspec.flutter.assets.contains(pubspec.genRes.strings.path)) {
      Logger.warning(
          """Please add the path ${pubspec.genRes.strings.path} into assets field like this in pubspec.yaml file
flutter:
  assets:
    - ${pubspec.genRes.strings.path}""");
    }
  }

  Future<String> _readTranslationFile() async {
    final translationContent =
        await File(pubspec.genRes.strings.path).readAsString();
    if (translationContent.isEmpty) {
      throw const InvalidSettingsException(
          'The value of "flutter/strings:" is incorrect.');
    }
    return translationContent;
  }

  List<List<String>> _parseCsvContent(String content) {
    return CsvToListConverter(csvSettingsDetector: csvSettingsDetector)
        .convert(content, fieldDelimiter: ',');
  }

  void _parseExistedLangs(List<List<String>> lines) {
    for (final line in lines.skip(1)) {
      final key = line.firstOrNull;
      final value = _convertListToLine(line);
      if ((key?.isEmpty ?? true) || (value?.isEmpty ?? true)) continue;
      result[key ?? ''] = value ?? '';
    }
  }

  void _parseFromExtendedFile() {
    final xlsxFile = File(pubspec.genRes.strings.xlsxPath ?? '');
    final bytes = xlsxFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    final sheetNames = pubspec.genRes.strings.sheetName != null
        ? [pubspec.genRes.strings.sheetName!]
        : excel.tables.keys.toList();

    for (final sheetName in sheetNames) {
      final rowsInSheet = excel.tables[sheetName]?.rows;
      if (rowsInSheet != null) {
        _parseSheet(rowsInSheet);
      }
    }
  }

  void _parseSheet(List<List<Data?>> rowsInSheet) {
    _parseLanguage(rowsInSheet);
    for (final key in keys) {
      final line = [key];
      for (final lang in langs) {
        final value = langMap[lang]?[key] ?? '';
        line.add(value);
      }
      final parsedLine = _convertListToLine(line);
      if (parsedLine != null) {
        result[key] = parsedLine;
      }
    }
  }

  String? _convertListToLine(List<String> line) {
    if (line.skip(1).every((word) => word.isEmpty)) return null;
    return line.map((word) => word.contains(',') ? '"$word"' : word).join(',');
  }

  void _parseLanguage(List<List<Data?>> rows) {
    final langIndexes = _getLangIndexes(rows);

    for (final row in rows.skip(1)) {
      final keyCell = row.first;
      final keyValue = keyCell?.value;
      if (keyValue is! TextCellValue ||
          (keyValue.value.text?.isEmpty ?? true)) {
        continue;
      }
      final key = keyValue.value.text ?? '';
      if (keys.contains(key)) continue;
      keys.add(key);
      for (final (lang, langIndex) in langIndexes) {
        _parseSingleLanguageFromRow(
            row: row, key: key, lang: lang, langIndex: langIndex);
      }
    }
  }

  List<(String, int)> _getLangIndexes(List<List<Data?>> rows) {
    return langs
        .map((lang) {
          final langIndex = rows.firstOrNull?.indexWhere((cell) {
            final value = cell?.value;
            return value is TextCellValue && value.value.text == lang;
          });
          if (langIndex != -1) {
            langMap[lang] = {};
            return (lang, langIndex);
          }
          return null;
        })
        .whereType<(String, int)>()
        .toList();
  }

  void _parseSingleLanguageFromRow({
    required List<Data?> row,
    required String key,
    required String lang,
    required int langIndex,
  }) {
    final langCell = row[langIndex];
    final langValue = langCell?.value;
    if (langValue is TextCellValue) {
      langMap[lang]?[key] = (langValue.value.text ?? '').replaceAll('\n', r'\n').trim();
    }
  }
}
