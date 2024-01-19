// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_res_drawable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenResDrawable _$GenResDrawableFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['enabled', 'path'],
  );
  return GenResDrawable(
    enabled: json['enabled'] as bool,
    path: json['path'] as String,
    output: json['output'] as String?,
    className: json['class_name'] as String?,
  );
}
