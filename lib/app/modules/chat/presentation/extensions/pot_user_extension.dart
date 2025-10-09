import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

extension PotInfoEntityX on PotInfoEntity {
  PotUserEntity? getMe(BuildContext context) {
    final meUser = AuthBloc.userOf(context);
    return usersInfo.users.firstWhereOrNull((u) => u.id == meUser?.id);
  }

  bool meIsHost(BuildContext context) => getMe(context)?.isHost ?? false;
}
