import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../models/pubspec.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import 'package:csv/csv_settings_autodetection.dart';

const String separator = '/// Extended';

class LangGenerator {
  LangGenerator({
    required this.pubspec,
  });

  static const csvSettingsDetector =
      FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

  final Pubspec pubspec;
  final String xlsxFilePath = 'assets/translations/language_source.xlsx';
  final String csvFilePath = 'assets/translations/langs.csv';
  final List<String> langs = ['EN', 'FR'];
  final Map<String, Map<String, String>> langMap = {};
  final List<String> keys = [];
  final StringBuffer buffer = StringBuffer();
  final List<List<String>> existedLangs = [];

  Future<String> generate() async {
    if (!pubspec.flutter.assets.contains(pubspec.genRes.strings.path)) {
      Logger.warning(
          """Please add the path ${pubspec.genRes.strings.path} into assets field like this in pubspec.yaml file
flutter:
  assets:
    - ${pubspec.genRes.strings.path}""");
    }

    final String translationContent =
        await File(pubspec.genRes.strings.path).readAsString();
    if (translationContent.isEmpty) {
      throw const InvalidSettingsException(
          'The value of "flutter/strings:" is incorrect.');
    }

    final List<String> rawList = translationContent.split(separator);

    existedLangs.addAll(
        CsvToListConverter(csvSettingsDetector: csvSettingsDetector)
            .convert(rawList[0], fieldDelimiter: ','));
    final List<String> existedWords = _generateExistedFile();
    final List<String> extendedLangs = _generateExtendedFile();
    buffer
      ..writeln(existedWords.join('\n'))
      ..writeln(separator)
      ..writeln(extendedLangs.join('\n'));

    return buffer.toString();
  }

  List<String> _generateExistedFile() {
    return existedLangs
        .map((line) => _convertListToLine(line))
        .where((parsedLine) => parsedLine != null)
        .cast<String>()
        .toList();
  }

  List<String> _generateExtendedFile() {
    final List<String> parsedLangs = [];
    final File xlsxFile = File(xlsxFilePath);
    final bytes = xlsxFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    for (final String table in excel.tables.keys) {
      final List<List<Data?>>? rowsInSheet = excel.tables[table]?.rows;
      final List<String> lines = _parseSheet(rowsInSheet: rowsInSheet);
      parsedLangs.addAll(lines);
    }
    return parsedLangs;
  }

  List<String> _parseSheet({required List<List<Data?>>? rowsInSheet}) {
    final List<String> parsedLangs = [];
    _parseLanguage(rowsInSheet ?? []);
    for (final String key in keys) {
      final List<String> line = [key];
      for (final String lang in langs) {
        final String value = langMap[lang]?[key] ?? '';
        line.add(value);
      }
      final String? parsedLine = _convertListToLine(line);
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
    final List<(String, int)> langIndexes = langs
        .map((lang) {
          final int langIndex = rows.first.indexWhere((cell) {
            final CellValue? value = cell?.value;
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

    for (final List<Data?> row in rows.skip(1)) {
      final Data? keyCell = row.first;
      final CellValue? keyValue = keyCell?.value;
      if (keyValue is! TextCellValue ||
          (keyValue.value.text?.isEmpty ?? true)) {
        continue;
      }
      final String key = keyValue.value.text ?? '';
      existedLangs.removeWhere((element) => element.first == key);
      keys.add(key);
      for (final (String lang, int langIndex) in langIndexes) {
        _parseLanguageFromRow(
          row: row,
          key: key,
          lang: lang,
          langIndex: langIndex,
        );
      }
    }
  }

  void _parseLanguageFromRow({
    required List<Data?> row,
    required String key,
    required String lang,
    required int langIndex,
  }) {
    final Data? langCell = row[langIndex];
    final CellValue? langValue = langCell?.value;
    if (langValue is TextCellValue) {
      langMap[lang]?[key] = langValue.value.text ?? '';
    }
  }
}
