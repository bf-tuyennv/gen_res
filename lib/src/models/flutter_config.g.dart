// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flutter _$FlutterFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['assets', 'fonts'],
  );
  return Flutter(
    assets: (json['assets'] as List<dynamic>).map((e) => e as String).toList(),
    fonts: (json['fonts'] as List<dynamic>)
        .map((e) => FlutterFont.fromJson(e as Map))
        .toList(),
  );
}
