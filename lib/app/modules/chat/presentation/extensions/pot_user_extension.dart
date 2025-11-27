import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';

extension PotOverviewEntityX on PotOverviewEntity {
  PotUserEntity? getMe(BuildContext context) {
    final meUser = AuthBloc.userOf(context);
    return usersInfo.users.firstWhereOrNull((u) => u.id == meUser?.id);
  }

  bool meIsHost(BuildContext context) => getMe(context)?.isHost ?? false;

  List<PotUserEntity> get passengers =>
      usersInfo.users.where((u) => u.isInPot).toList();
  List<PotUserEntity> getPassengersExceptMe(BuildContext context) => usersInfo
      .users
      .where((u) => u.isInPot && u.id != AuthBloc.userOf(context)?.id)
      .toList();
  List<PotUserEntity> getUsersExceptMe(BuildContext context) => usersInfo.users
      .where((u) => u.id != AuthBloc.userOf(context)?.id)
      .toList();
}
