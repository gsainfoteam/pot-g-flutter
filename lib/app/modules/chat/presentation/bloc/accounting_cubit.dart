import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

part 'accounting_cubit.freezed.dart';

@injectable
class AccountingCubit extends Cubit<AccountingState> {
  AccountingCubit() : super(const AccountingState());

  void amountChanged(int? amount) => emit(state.copyWith(amount: amount));
  void loadTargets(Iterable<PotUserEntity> users) =>
      emit(state.copyWith(targets: users.toSet()));
  void toggleUser(PotUserEntity user, bool value) {
    final set = state.targets?.toSet() ?? {};
    if (value) {
      set.add(user);
    } else {
      set.remove(user);
    }
    emit(state.copyWith(targets: set));
  }
}

@freezed
sealed class AccountingState with _$AccountingState {
  const AccountingState._();
  const factory AccountingState({int? amount, Set<PotUserEntity>? targets}) =
      _AccountingState;

  bool get valid => amount != null && targets != null;
}
