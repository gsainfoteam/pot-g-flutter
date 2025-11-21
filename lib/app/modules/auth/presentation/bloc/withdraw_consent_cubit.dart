import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'withdraw_consent_cubit.freezed.dart';

@injectable
class WithdrawConsentCubit extends Cubit<WithdrawConsentState> {
  WithdrawConsentCubit() : super(const WithdrawConsentState());

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
sealed class WithdrawConsentState with _$WithdrawConsentState {
  const WithdrawConsentState._();

  const factory WithdrawConsentState({
    @Default(false) bool accountDeletionConsent,
    @Default(false) bool potInfoDeletionConsent,
    @Default(false) bool restoreUnavailableConsent,
  }) = _WithdrawConsentState;

  int get checkedCount => [
    accountDeletionConsent,
    potInfoDeletionConsent,
    restoreUnavailableConsent,
  ].where((consent) => consent).length;

  bool get anyChecked => checkedCount > 0;
  bool get allChecked => checkedCount == 3;
}
