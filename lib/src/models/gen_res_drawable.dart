import 'package:json_annotation/json_annotation.dart';

part 'gen_res_drawable.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResDrawable {
  GenResDrawable({
    required this.enabled,
    required this.path,
    required this.output,
    required this.className,
  });

  @JsonKey(name: 'enabled', required: true)
  final bool enabled;

  @JsonKey(name: 'path', required: true)
  final String path;

  @JsonKey(name: 'output', required: false)
  final String? output;

  @JsonKey(name: 'class_name', required: false)
  final String? className;

  factory GenResDrawable.fromJson(Map json) => _$GenResDrawableFromJson(json);
}
