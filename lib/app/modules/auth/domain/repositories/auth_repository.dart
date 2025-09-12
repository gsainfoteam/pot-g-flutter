import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn();
  Stream<bool> get isSignedIn;
  Future<void> signOut();
  Stream<UserEntity?> get user;
}
