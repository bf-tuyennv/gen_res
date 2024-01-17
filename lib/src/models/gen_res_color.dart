import 'package:json_annotation/json_annotation.dart';

part 'gen_res_color.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResColor {
  GenResColor({required this.enabled, required this.path});

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  @JsonKey(name: 'path', required: true)
  final String path;

  factory GenResColor.fromJson(Map json) => _$GenResColorFromJson(json);
}
