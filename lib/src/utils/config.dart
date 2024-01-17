import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../models/pubspec.dart';
import 'const.dart';
import 'map.dart';

class Config {
  Config._({required this.pubspec});

  final Pubspec pubspec;
}

Future<Config> loadPubspecConfig(File pubspecFile) async {
  stdout.writeln('GenRes Loading ... '
      '${normalize(join(
    basename(pubspecFile.parent.path),
    basename(pubspecFile.path),
  ))}');
  final content = await pubspecFile.readAsString().catchError((dynamic error) {
    throw FileSystemException('Cannot open pubspec.yaml: ${pubspecFile.absolute}');
  });
  final userMap = loadYaml(content) as Map?;
  final defaultMap = loadYaml(Const.defaultConfig) as Map?;
  final mergedMap = MapUtils.mergeMap([defaultMap, userMap]);
  final pubspec = Pubspec.fromJson(mergedMap);
  return Config._(pubspec: pubspec);
}