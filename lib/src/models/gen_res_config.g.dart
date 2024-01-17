// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_res_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenResConfig _$GenResConfigFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'output',
      'line_length',
      'generate_R',
      'drawable',
      'fonts',
      'colors',
      'strings'
    ],
  );
  return GenResConfig(
    output: json['output'] as String,
    lineLength: json['line_length'] as int,
    generateR: json['generate_R'] as bool,
    drawables: GenResDrawable.fromJson(json['drawable'] as Map),
    fonts: GenResFont.fromJson(json['fonts'] as Map),
    colors: GenResColor.fromJson(json['colors'] as Map),
    strings: GenResString.fromJson(json['strings'] as Map),
  );
}
