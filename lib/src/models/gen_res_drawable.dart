import 'package:json_annotation/json_annotation.dart';

part 'gen_res_drawable.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResDrawable {
  GenResDrawable({
    required this.enabled,
    required this.path,
  });

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  @JsonKey(name: 'path', required: true)
  final String path;

  factory GenResDrawable.fromJson(Map json) => _$GenResDrawableFromJson(json);
}
