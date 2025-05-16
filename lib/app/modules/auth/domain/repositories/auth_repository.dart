abstract class AuthRepository {
  Future<void> signIn();
  Stream<bool> get isSignedIn;
  Future<void> signOut();
}
