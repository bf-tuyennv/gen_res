// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_res_string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenResString _$GenResStringFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['enabled', 'path'],
  );
  return GenResString(
    enabled: json['enabled'] as bool,
    path: json['path'] as String,
    xlsxPath: json['xlsx_path'] as String?,
    supportedLangs: (json['supported_langs'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    sheetName: json['sheet_name'] as String?,
  );
}
