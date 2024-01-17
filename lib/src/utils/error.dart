abstract class GenerateError {
  late final String message;
}

class InvalidSettingsException implements Exception, GenerateError {
  const InvalidSettingsException(this.message);

  @override
  final String message;

  @override
  set message(String message) {
    message = message;
  }
}

class Duplicated implements Exception, GenerateError {
  const Duplicated(this.message);

  @override
  final String message;

  @override
  set message(String message) {
    message = message;
  }
}
