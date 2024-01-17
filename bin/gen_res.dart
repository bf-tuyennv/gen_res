import 'dart:io';

import 'package:args/args.dart';
import 'package:gen_res/src/generators/flutter_generator.dart';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addOption(
    'config',
    abbr: 'c',
    help: 'Set the path of pubspec.yaml.',
    defaultsTo: 'pubspec.yaml',
  );

  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Help about any command',
    defaultsTo: false,
  );

  ArgResults results;
  try {
    results = parser.parse(args);
    if (results.wasParsed('help')) {
      stdout.writeln(parser.usage);
      return;
    }
  } on FormatException catch (e) {
    stderr.writeAll(<String>[e.message, 'usage: gen_res [options...] ', ''], '\n');
    return;
  }

  final pubspecPath = results['config'];
  if (pubspecPath is! String || pubspecPath.isEmpty) return;
  Generator(File(pubspecPath).absolute).build();
}
