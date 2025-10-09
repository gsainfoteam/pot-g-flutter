import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/accounting_repository.dart';

part 'set_bank_account_bloc.freezed.dart';

@injectable
class SetBankAccountBloc
    extends Bloc<SetBankAccountEvent, SetBankAccountState> {
  final AccountingRepository _repository;
  SetBankAccountBloc(this._repository) : super(SetBankAccountState.initial()) {
    on<_Set>(_onSet);
  }

  Future<void> _onSet(
    SetBankAccountEvent event,
    Emitter<SetBankAccountState> emit,
  ) async {
    emit(const SetBankAccountState.loading());
    try {
      await _repository.setAccounting(event.bank, event.accountNumber);
      emit(const SetBankAccountState.success());
    } catch (e) {
      emit(SetBankAccountState.error(e.toString()));
    }
  }
}

@freezed
sealed class SetBankAccountEvent with _$SetBankAccountEvent {
  const factory SetBankAccountEvent.set(BankEntity bank, String accountNumber) =
      _Set;
}

@freezed
sealed class SetBankAccountState with _$SetBankAccountState {
  const SetBankAccountState._();
  const factory SetBankAccountState.initial() = _Initial;
  const factory SetBankAccountState.loading() = _Loading;
  const factory SetBankAccountState.success() = _Success;
  const factory SetBankAccountState.error(String message) = _Error;

  bool get isSuccess => switch (this) {
    _Success() => true,
    _ => false,
  };
  String? get errorMessage => switch (this) {
    _Error(:final message) => message,
    _ => null,
  };
}
