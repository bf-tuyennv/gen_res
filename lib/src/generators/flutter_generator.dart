import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

import 'colors_generator.dart';
import 'drawable_generator.dart';
import 'fonts_generator.dart';
import 'lang_generator.dart';
import 'resource_generator.dart';
import 'strings_generator.dart';
import '../utils/config.dart';
import '../utils/error.dart';
import '../utils/file.dart';
import '../utils/logger.dart';
import '../utils/version.dart';

class Generator {
  const Generator(
    this.pubspecFile, {
    this.drawablesName = 'app_images.g.dart',
    this.colorsName = 'app_colors.g.dart',
    this.fontsName = 'app_fonts.g.dart',
    this.stringsName = 'app_labels.g.dart',
  });

  final File pubspecFile;
  final String drawablesName;
  final String colorsName;
  final String fontsName;
  final String stringsName;

  Future<void> build() async {
    stdout.writeln(genResVersion);
    Config config;
    try {
      config = await loadPubspecConfig(pubspecFile);
    } on GenerateError catch (e) {
      Logger.error(e.message);
      return;
    } on FileSystemException catch (e) {
      Logger.error(e.message);
      return;
    }

    final flutter = config.pubspec.flutter;
    final genRes = config.pubspec.genRes;
    final output = config.pubspec.genRes.output;
    final lineLength = config.pubspec.genRes.lineLength;
    final formatter = DartFormatter(pageWidth: lineLength, lineEnding: '\n');

    final absoluteOutput = Directory(normalize(join(pubspecFile.parent.path, output)));
    if (!absoluteOutput.existsSync()) {
      absoluteOutput.createSync(recursive: true);
    }

    try {
      if (genRes.strings.xlsxPath?.isNotEmpty ?? false) {
        final LangGenerator generator = LangGenerator(
          pubspec: config.pubspec,
        );
        final generated = await generator.generate();
        final lang = File(normalize(
            join(pubspecFile.parent.path, config.pubspec.genRes.strings.path)));
        FileUtils.writeAsString(generated, file: lang);
      }

      if (genRes.drawables.enabled) {
        final DrawableGenerator generator = DrawableGenerator(
          rootPath: pubspecFile.parent.path,
          pubspec: config.pubspec,
          formatter: formatter,
        );
        final generated = generator.generate();
        final assets = File(normalize(join(pubspecFile.parent.path, output, drawablesName)));
        FileUtils.writeAsString(generated, file: assets);
        stdout.writeln('Generated: ${assets.absolute.path}');
      }

      if (genRes.colors.enabled) {
        final ColorGenerator generator = ColorGenerator(
          pubspecFile: pubspecFile,
          formatter: formatter,
          colors: genRes.colors,
        );
        final generated = await generator.generate();
        final colors = File(normalize(join(pubspecFile.parent.path, output, colorsName)));
        FileUtils.writeAsString(generated, file: colors);
        stdout.writeln('Generated: ${colors.absolute.path}');
      }

      if (genRes.strings.enabled) {
        final StringGenerator generator = StringGenerator(
          pubspec: config.pubspec,
          formatter: formatter,
        );
        final generated = await generator.generate();
        final strings = File(normalize(join(pubspecFile.parent.path, output, stringsName)));
        FileUtils.writeAsString(generated, file: strings);
        stdout.writeln('Generated: ${strings.absolute.path}');
      }

      if (genRes.fonts.enabled) {
        final FontGenerator generator = FontGenerator(
          formatter: formatter,
          fonts: flutter.fonts,
        );
        final generated = generator.generate();
        final fonts = File(normalize(join(pubspecFile.parent.path, output, fontsName)));
        FileUtils.writeAsString(generated, file: fonts);
        stdout.writeln('Generated: ${fonts.absolute.path}');
      }

      if (genRes.generateR) {
        if (await File(join(pubspecFile.parent.path, output, 'R.dart')).exists()) {
          Logger.debug('R.dart file exists, not re-generate!');
        } else {
          final ResourceGenerator generator = ResourceGenerator(
            pubspecFile: pubspecFile,
            formatter: formatter,
            drawablesName: genRes.drawables.enabled ? drawablesName : null,
            stringsName: genRes.strings.enabled ? stringsName : null,
            colorsName: genRes.colors.enabled ? colorsName : null,
            fontsName: genRes.fonts.enabled ? fontsName : null,
          );
          final generated = generator.generate();
          final resource = File(normalize(join(pubspecFile.parent.path, output, 'R.dart')));
          FileUtils.writeAsString(generated, file: resource);
          stdout.writeln('Generated: ${resource.absolute.path}');
        }
      }

      stdout.writeln('GenRes finished.');
    } on GenerateError catch (e) {
      Logger.error(e.message);
      return;
    } on FileSystemException catch (e) {
      Logger.error(e.message);
      return;
    }
  }
}
