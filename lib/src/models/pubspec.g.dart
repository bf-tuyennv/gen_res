// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pubspec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pubspec _$PubspecFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'gen_res', 'flutter'],
  );
  return Pubspec(
    packageName: json['name'] as String,
    genRes: GenResConfig.fromJson(json['gen_res'] as Map),
    flutter: Flutter.fromJson(json['flutter'] as Map),
  );
}
