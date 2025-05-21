class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final String idToken;

  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  });

  @override
  String toString() {
    return 'TokenEntity(accessToken: $accessToken, refreshToken: $refreshToken, idToken: $idToken)';
  }
}
