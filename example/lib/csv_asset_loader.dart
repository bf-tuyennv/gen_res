import 'dart:developer';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

//
// load example/resources/langs/langs.csv
//
class CsvAssetLoader extends AssetLoader {
  CSVParser? csvParser;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    if (csvParser == null) {
      log('easy localization loader: load csv file $path');
      csvParser = CSVParser(await rootBundle.loadString(path));
    } else {
      log('easy localization loader: CSV parser already loaded, read cache');
    }
    return csvParser!.getLanguageMap(locale.toString());
  }
}

class CSVParser {
  final String fieldDelimiter;
  final String strings;
  final List<List<dynamic>> lines;

  static const csvSettingsDetector = FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

  CSVParser(this.strings, {this.fieldDelimiter = ','})
      : lines = const CsvToListConverter(csvSettingsDetector: csvSettingsDetector)
            .convert(strings, fieldDelimiter: fieldDelimiter);

  List getLanguages() {
    return lines.first.sublist(1, lines.first.length);
  }

  Map<String, dynamic> getLanguageMap(String localeName) {
    final indexLocale = lines.first.indexOf(localeName);

    final translations = <String, dynamic>{};
    for (var i = 1; i < lines.length; i++) {
      translations.addAll({lines[i][0]: lines[i][indexLocale].replaceAll('\\n', '\n')});
    }
    return translations;
  }
}
