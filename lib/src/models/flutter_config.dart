import 'package:json_annotation/json_annotation.dart';

import 'flutter_font.dart';

part 'flutter_config.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class Flutter {
  Flutter({required this.assets, required this.fonts});

  @JsonKey(name: 'assets', required: true)
  final List<String> assets;

  @JsonKey(name: 'fonts', required: true)
  final List<FlutterFont> fonts;

  factory Flutter.fromJson(Map json) => _$FlutterFromJson(json);
}
