import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'withdraw_cubit.freezed.dart';

@injectable
class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit() : super(const WithdrawState());

  void toggleAccountDeletionConsent(bool value) {
    emit(state.copyWith(accountDeletionConsent: value));
  }

  void togglePotInfoDeletionConsent(bool value) {
    emit(state.copyWith(potInfoDeletionConsent: value));
  }

  void toggleRestoreUnavailableConsent(bool value) {
    emit(state.copyWith(restoreUnavailableConsent: value));
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
