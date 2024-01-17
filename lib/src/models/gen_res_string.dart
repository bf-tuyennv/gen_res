import 'package:json_annotation/json_annotation.dart';

part 'gen_res_string.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResString {
  GenResString({required this.enabled, required this.path});

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  @JsonKey(name: 'path', required: true)
  final String path;

  factory GenResString.fromJson(Map json) => _$GenResStringFromJson(json);
}
