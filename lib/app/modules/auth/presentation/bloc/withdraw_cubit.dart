import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'withdraw_cubit.freezed.dart';

@injectable
class WithdrawCubit extends Cubit<WithdrawState> {
  final AuthRepository _repository;

  WithdrawCubit(this._repository) : super(const WithdrawState());

  void toggleAccountDeletionConsent(bool value) {
    emit(state.copyWith(accountDeletionConsent: value));
  }

  void togglePotInfoDeletionConsent(bool value) {
    emit(state.copyWith(potInfoDeletionConsent: value));
  }

  void toggleRestoreUnavailableConsent(bool value) {
    emit(state.copyWith(restoreUnavailableConsent: value));
  }

  Future<void> withdraw() async {
    if (!state.allChecked) {
      return;
    }

    emit(state.copyWith());

    try {
      await _repository.withdraw();
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
    }
  }
}

@freezed
sealed class WithdrawState with _$WithdrawState {
  const WithdrawState._();

  const factory WithdrawState({
    @Default(false) bool accountDeletionConsent,
    @Default(false) bool potInfoDeletionConsent,
    @Default(false) bool restoreUnavailableConsent,
  }) = _WithdrawState;

  int get checkedCount => [
    accountDeletionConsent,
    potInfoDeletionConsent,
    restoreUnavailableConsent,
  ].where((consent) => consent).length;

  bool get anyChecked => checkedCount > 0;
  bool get allChecked => checkedCount == 3;
}
