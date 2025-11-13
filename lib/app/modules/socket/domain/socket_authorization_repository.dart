abstract interface class SocketAuthorizationRepository {
  Future<void> connect();
  Future<void> disconnect();
}
