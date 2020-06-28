class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class NoInternetException extends AppException {
  NoInternetException([String message])
      : super(message, "Error During Communication: ");
}

class InvalidTokenException extends AppException {
  InvalidTokenException([String message])
      : super(message, "Error During Communication: ");
}

class UnknownException extends AppException {
  UnknownException([String message])
      : super(message, "Error During Communication: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message])
      : super(message, "Error During Communication: ");
}
