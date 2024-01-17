import 'package:json_annotation/json_annotation.dart';

part 'flutter_font.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class FlutterFont {
  FlutterFont({required this.family});

  @JsonKey(name: 'family', required: true)
  final String family;

  factory FlutterFont.fromJson(Map json) => _$FlutterFontFromJson(json);
}
