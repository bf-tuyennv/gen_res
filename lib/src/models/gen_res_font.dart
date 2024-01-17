import 'package:json_annotation/json_annotation.dart';

part 'gen_res_font.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResFont {
  GenResFont({required this.enabled});

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  factory GenResFont.fromJson(Map json) => _$GenResFontFromJson(json);
}
