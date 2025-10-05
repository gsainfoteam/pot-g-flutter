import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

class SelfUserEntity extends UserEntity {
  final String email;

  const SelfUserEntity({
    required this.email,
    required super.id,
    required super.name,
  });
}
