class Const {
  static const String invalidStringValue = 'GEN_RES_INVALID';

  static const defaultConfig = '''
name: ${Const.invalidStringValue}

gen_res:
  output: lib/generated/
  line_length: 120
  generate_R: false

  drawable:
    enabled: false
    path: assets/images/

  strings:
    enabled: false
    path: assets/translations/langs.csv
    
  fonts:
    enabled: false

  colors:
    enabled: false
    path: assets/colors/colors.xml

flutter:
  assets: []
  fonts: []
''';
}
