import 'package:json_annotation/json_annotation.dart';

import 'gen_res_color.dart';
import 'gen_res_drawable.dart';
import 'gen_res_font.dart';
import 'gen_res_string.dart';

part 'gen_res_config.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class GenResConfig {
  GenResConfig({
    required this.output,
    required this.lineLength,
    required this.generateR,
    required this.drawables,
    required this.fonts,
    required this.colors,
    required this.strings,
  });

  @JsonKey(name: 'output', required: true)
  final String output;

  @JsonKey(name: 'line_length', required: true)
  final int lineLength;

  @JsonKey(name: 'generate_R', required: true)
  final bool generateR;

  @JsonKey(name: 'drawable', required: true)
  final GenResDrawable drawables;

  @JsonKey(name: 'fonts', required: true)
  final GenResFont fonts;

  @JsonKey(name: 'colors', required: true)
  final GenResColor colors;

  @JsonKey(name: 'strings', required: true)
  final GenResString strings;

  factory GenResConfig.fromJson(Map json) => _$GenResConfigFromJson(json);
}
