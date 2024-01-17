import 'dart:io';

class Logger {
  static void error(dynamic message) {
    stderr.writeln('====================Error====================');
    stderr.writeln();

    stderr.writeln(message.toString());

    stderr.writeln();
    stderr.writeln('=============================================');
  }

  static void warning(dynamic message) {
    stdout.writeln('===================Warning===================');
    stdout.writeln();

    stdout.writeln(message.toString());

    stdout.writeln();
    stdout.writeln('==============================================');
  }

  static void debug(dynamic message) {
    stdout.writeln();
    stdout.writeln('==========Debug==========> ${message.toString()}');
    stdout.writeln();
  }

  static void debugContent(dynamic message) {
    stdout.writeln('====================Debug====================');
    stdout.writeln();

    stdout.writeln(message.toString());

    stdout.writeln();
    stdout.writeln('=============================================');
  }
}
