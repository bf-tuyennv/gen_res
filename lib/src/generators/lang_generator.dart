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
  final List<String> langs = [];
  final Map<String, Map<String, String>> langMap = {};
  final List<String> keys = [];
  final StringBuffer buffer = StringBuffer();
  final List<List<String>> existedLangs = [];

  Future<String> generate() async {
    _validateSettings();
    _loadSupportedLangs();
    _checkAssetsPath();

    final translationContent = await _readTranslationFile();
    _parseExistedLangs(translationContent);

    final extendedLangs = _parseFromExtendedFile();
    final existedWords = _parseFromExistedFile();

    buffer
      ..writeln(existedWords.join('\n'))
      ..writeln(pubspec.genRes.strings.separator ?? '')
      ..writeln(extendedLangs.join('\n'));

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

  void _parseExistedLangs(String translationContent) {
    final rawList =
        translationContent.split(pubspec.genRes.strings.separator ?? '');
    existedLangs.addAll(
        CsvToListConverter(csvSettingsDetector: csvSettingsDetector)
            .convert(rawList[0], fieldDelimiter: ','));
  }

  List<String> _parseFromExistedFile() {
    return existedLangs
        .map(_convertListToLine)
        .where((parsedLine) => parsedLine != null)
        .cast<String>()
        .toList();
  }

  List<String> _parseFromExtendedFile() {
    final parsedLangs = <String>[];
    final xlsxFile = File(pubspec.genRes.strings.xlsxPath ?? '');
    final bytes = xlsxFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final rowsInSheet = excel.tables[table]?.rows;
      final lines = _parseSheet(rowsInSheet: rowsInSheet);
      parsedLangs.addAll(lines);
    }
    return parsedLangs;
  }

  List<String> _parseSheet({required List<List<Data?>>? rowsInSheet}) {
    final parsedLangs = <String>[];
    _parseLanguage(rowsInSheet ?? []);
    for (final key in keys) {
      final line = [key];
      for (final lang in langs) {
        final value = langMap[lang]?[key] ?? '';
        line.add(value);
      }
      final parsedLine = _convertListToLine(line);
      if (parsedLine != null) {
        parsedLangs.add(parsedLine);
      }
    }
    return parsedLangs;
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
      existedLangs.removeWhere((element) => element.first == key);
      keys.add(key);
      for (final (lang, langIndex) in langIndexes) {
        _parseLanguageFromRow(
            row: row, key: key, lang: lang, langIndex: langIndex);
      }
    }
  }

  List<(String, int)> _getLangIndexes(List<List<Data?>> rows) {
    return langs
        .map((lang) {
          final langIndex = rows.first.indexWhere((cell) {
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

  void _parseLanguageFromRow({
    required List<Data?> row,
    required String key,
    required String lang,
    required int langIndex,
  }) {
    final langCell = row[langIndex];
    final langValue = langCell?.value;
    if (langValue is TextCellValue) {
      langMap[lang]?[key] = langValue.value.text ?? '';
    }
  }
}
