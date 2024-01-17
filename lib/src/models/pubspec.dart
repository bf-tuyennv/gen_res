import 'package:json_annotation/json_annotation.dart';

import 'gen_res_config.dart';
import 'flutter_config.dart';

part 'pubspec.g.dart';

/// After edit this file, please comment the build.yaml file before run 'flutter pub run build_runner build'

@JsonSerializable(anyMap: true, explicitToJson: true, createToJson: false)
class Pubspec {
  Pubspec({
    required this.packageName,
    required this.genRes,
    required this.flutter,
  });

  @JsonKey(name: 'name', required: true)
  final String packageName;

  @JsonKey(name: 'gen_res', required: true)
  final GenResConfig genRes;

  @JsonKey(name: 'flutter', required: true)
  final Flutter flutter;

  factory Pubspec.fromJson(Map json) => _$PubspecFromJson(json);
}
