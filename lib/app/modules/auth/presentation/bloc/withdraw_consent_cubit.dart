import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/enums/withdraw_consent_type.dart';

part 'withdraw_consent_cubit.freezed.dart';

@injectable
class WithdrawConsentCubit extends Cubit<WithdrawConsentState> {
  WithdrawConsentCubit() : super(const WithdrawConsentState());

  void toggleConsent(WithdrawConsentType type, bool value) {
    final newConsents = value
        ? state.consents.union({type})
        : state.consents.difference({type});
    emit(state.copyWith(consents: newConsents));
  }
}

@freezed
sealed class WithdrawConsentState with _$WithdrawConsentState {
  const WithdrawConsentState._();

  const factory WithdrawConsentState({
    @Default({}) Set<WithdrawConsentType> consents,
  }) = _WithdrawConsentState;

  int get checkedCount => consents.length;
  bool get anyChecked => checkedCount != 0;
  bool get allChecked => checkedCount == WithdrawConsentType.values.length;
}
