import 'dart:io';

import 'package:color/color.dart';
import 'package:mime/mime.dart';

class ColorUtils {
  /// e.g. 0xBB1122 -> #BB1122
  static String hexFromColor(String hexColor) {
    return hexColor.replaceFirst('0x', '#').toUpperCase();
  }

  /// e.g. #BB1122 -> FFBB1122
  static String colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceFirst('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return '0x$hexColor';
  }

  /// [Material Design Color Generator](https://github.com/mbitson/mcg)
  /// Constantin/Buckner logic: https://github.com/mbitson/mcg/blob/858cffea0d79ac143d590d110fbe20a1ea54d59d/scripts/controllers/ColorGeneratorCtrl.js#L238
  static Map<int, String> swatchFromPrimaryHex(String primaryHex) {
    final primary = Color.hex(primaryHex);
    final baseLight = Color.hex("ffffff");
    final baseDark = primary * primary;
    return {
      50: _mix(baseLight, primary, 12).toHexString(),
      100: _mix(baseLight, primary, 30).toHexString(),
      200: _mix(baseLight, primary, 50).toHexString(),
      300: _mix(baseLight, primary, 70).toHexString(),
      400: _mix(baseLight, primary, 85).toHexString(),
      500: _mix(baseLight, primary, 100).toHexString(),
      600: _mix(baseDark, primary, 87).toHexString(),
      700: _mix(baseDark, primary, 70).toHexString(),
      800: _mix(baseDark, primary, 54).toHexString(),
      900: _mix(baseDark, primary, 25).toHexString(),
    };
  }

  /// Buckner logic: https://github.com/mbitson/mcg/blob/858cffea0d79ac143d590d110fbe20a1ea54d59d/scripts/controllers/ColorGeneratorCtrl.js#L275
  static Map<int, String> accentSwatchFromPrimaryHex(String primaryHex) {
    final primary = Color.hex(primaryHex);
    final baseDark = primary * primary;
    final baseTriad = primary.tetrad();
    return {
      100: _mix(baseDark, baseTriad[3], 15).saturate(80).lighten(48).toHexString(),
      200: _mix(baseDark, baseTriad[3], 15).saturate(80).lighten(36).toHexString(),
      400: _mix(baseDark, baseTriad[3], 15).saturate(100).lighten(31).toHexString(),
      700: _mix(baseDark, baseTriad[3], 15).saturate(100).lighten(28).toHexString(),
    };
  }

  // https://github.com/bgrins/TinyColor/blob/96592a5cacdbf4d4d16cd7d39d4d6dd28da9bd5f/tinycolor.js#L701
  static Color _mix(
    Color color1,
    Color color2,
    int amount,
  ) {
    assert(amount >= 0 && amount <= 100);
    final p = amount / 100;
    final color10 = color1.toRgbColor();
    final color20 = color2.toRgbColor();
    return Color.rgb(
      ((color20.r - color10.r) * p + color10.r).round(),
      ((color20.g - color10.g) * p + color10.g).round(),
      ((color20.b - color10.b) * p + color10.b).round(),
    );
  }
}

/// https://github.com/dart-lang/mime/blob/master/lib/src/default_extension_map.dart
class ColorPath {
  const ColorPath(this.path);

  final String path;

  File get file => File(path);

  String? get mime => lookupMimeType(path);

  /// https://api.flutter.dev/flutter/widgets/Image-class.html
  bool get isXml => mime == 'application/xml';
}

extension _ColorExtend on Color {
  String toHexString() {
    return '0xFF${toHexColor().toString().toUpperCase()}';
  }

  // https://github.com/mbitson/mcg/blob/858cffea0d79ac143d590d110fbe20a1ea54d59d/scripts/controllers/ColorGeneratorCtrl.js#L221
  Color operator *(Color other) {
    return Color.rgb(
      (toRgbColor().r * other.toRgbColor().r / 255).floor(),
      (toRgbColor().g * other.toRgbColor().g / 255).floor(),
      (toRgbColor().b * other.toRgbColor().b / 255).floor(),
    );
  }

  // https://github.com/bgrins/TinyColor/blob/ab58ca0a3738dc06b7e64c749cebfd5d6fb5044c/tinycolor.js#L647
  List<Color> tetrad() {
    final hsl = toHslColor();
    return [
      this,
      Color.hsl((hsl.h + 90) % 360, hsl.s, hsl.l),
      Color.hsl((hsl.h + 180) % 360, hsl.s, hsl.l),
      Color.hsl((hsl.h + 270) % 360, hsl.s, hsl.l),
    ];
  }

  // https://github.com/bgrins/TinyColor/blob/ab58ca0a3738dc06b7e64c749cebfd5d6fb5044c/tinycolor.js#L580
  Color saturate(int amount) {
    assert(amount >= 0 && amount <= 100);
    final hsl = toHslColor();
    final s = (hsl.s + amount).clamp(0, 100);
    return Color.hsl(hsl.h, s, hsl.l);
  }

  // https://github.com/bgrins/TinyColor/blob/ab58ca0a3738dc06b7e64c749cebfd5d6fb5044c/tinycolor.js#L592
  Color lighten(int amount) {
    assert(amount >= 0 && amount <= 100);
    final hsl = toHslColor();
    final l = (hsl.l + amount).clamp(0, 100);
    return Color.hsl(hsl.h, hsl.s, l);
  }
}
