import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:pot_g/app/modules/auth/domain/entities/withdraw_consent_entity.dart';

abstract interface class AuthRepository {
  Future<SelfUserEntity> signIn();
  Stream<bool> get isSignedIn;
  Future<void> signOut();
  Stream<SelfUserEntity?> get user;
  Future<void> update();
  Future<void> withdraw(List<WithdrawConsentEntity> consents);
}
