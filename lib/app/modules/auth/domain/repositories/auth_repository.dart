import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';

abstract class AuthRepository {
  Future<SelfUserEntity> signIn();
  Stream<bool> get isSignedIn;
  Future<void> signOut();
  Stream<SelfUserEntity?> get user;
}
