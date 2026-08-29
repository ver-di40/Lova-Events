import '../enums/fret_enums.dart';

class FretException implements Exception {
  const FretException(this.code, this.message);

  final FretErrorCode code;
  final String message;

  @override
  String toString() => 'FretException(code: $code, message: $message)';
}
