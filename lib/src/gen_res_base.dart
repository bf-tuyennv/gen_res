import 'dart:io';

import 'package:build/build.dart';
import 'generators/flutter_generator.dart';

Builder build(BuilderOptions options) {
  stdout.writeln('GenRes start');
  Future(() async {
    await Generator(File('pubspec.yaml')).build();
  });
  return EmptyBuilder();
}

class EmptyBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions => {};
}
