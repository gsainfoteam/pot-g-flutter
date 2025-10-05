abstract class SocketAuthorizationRepository {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> authorize();
}
