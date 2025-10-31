sealed class AuthorizationException implements Exception {
  const AuthorizationException();
  @override
  String toString() => 'AuthorizationException';
}

class InvalidAuthorizationStateException extends AuthorizationException {
  const InvalidAuthorizationStateException();
  @override
  String toString() => 'InvalidAuthorizationStateException';
}

class InvalidAuthorizationCodeException extends AuthorizationException {
  const InvalidAuthorizationCodeException();
  @override
  String toString() => 'InvalidAuthorizationCodeException';
}

class NetworkErrorException extends AuthorizationException {
  final String error;
  const NetworkErrorException(this.error);
  @override
  String toString() => 'NetworkErrorException(error: $error)';
}

class UnknownException extends AuthorizationException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'UnknownException(error: $error)';
}
