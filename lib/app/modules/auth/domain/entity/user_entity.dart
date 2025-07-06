import 'package:equatable/equatable.dart';

class UserEntity with EquatableMixin {
  final String email;
  final String name;
  final String uuid;

  const UserEntity({
    required this.email,
    required this.name,
    required this.uuid,
  });

  @override
  List<Object?> get props => [email, name, uuid];
}
