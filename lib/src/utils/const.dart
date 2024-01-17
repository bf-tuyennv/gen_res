class Const {
  static const String invalidStringValue = 'GEN_RES_INVALID';

  static const defaultConfig = '''
name: ${Const.invalidStringValue}

gen_res:
  output: lib/generated/
  line_length: 120
  generate_R: true

  drawable:
    enabled: true
    path: assets/images/

  strings:
    enabled: true
    path: assets/translations/langs.csv
    
  fonts:
    enabled: true

  colors:
    enabled: true
    path: assets/colors/colors.xml

flutter:
  assets: []
  fonts: []
''';
}
