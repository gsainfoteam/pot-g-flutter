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
