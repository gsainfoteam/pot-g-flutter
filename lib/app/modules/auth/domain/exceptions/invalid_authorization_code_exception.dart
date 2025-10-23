class InvalidAuthorizationCodeException implements Exception {
  const InvalidAuthorizationCodeException();
  @override
  String toString() => 'InvalidAuthorizationCodeException';
}
