import 'package:json_annotation/json_annotation.dart';

part 'gen_res_string.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResString {
  GenResString({
    required this.enabled,
    required this.path,
    this.xlsxPath,
    this.supportedLangs,
    this.separator,
    this.sheetName,
    this.hasExtended,
  });

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  @JsonKey(name: 'path', required: true)
  final String path;

  @JsonKey(name: 'xlsx_path', required: false)
  final String? xlsxPath;

  @JsonKey(name: 'supported_langs', required: false)
  final List<String>? supportedLangs;

  @JsonKey(name: 'separator', required: false)
  final String? separator;

  @JsonKey(name: 'sheet_name', required: false)
  final String? sheetName;

  @JsonKey(name: 'has_extended', required: false)
  final bool? hasExtended;

  factory GenResString.fromJson(Map json) => _$GenResStringFromJson(json);

  @override
  String toString() {
    return 'GenResString{enabled: $enabled, path: $path, xlsxPath: $xlsxPath, supportedLangs: $supportedLangs, separator: $separator, sheetName: $sheetName}';
  }
}
