String get header {
  return '''/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  GenRes
/// *****************************************************
library;

''';
}

String get ignoreAnalysis {
  return '''// ignore_for_file: directives_ordering,unnecessary_import,constant_identifier_names,non_constant_identifier_names
  
''';
}

String import(String package) => 'import \'$package\';';

// Replace to Posix style for Windows separator.
String posixStyle(String path) => path.replaceAll(r'\', r'/');
