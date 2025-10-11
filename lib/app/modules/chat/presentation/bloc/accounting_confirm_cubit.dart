import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/accounting_result_entity.dart';

part 'accounting_confirm_cubit.freezed.dart';

@injectable
class AccountingConfirmCubit extends Cubit<AccountingConfirmState> {
  AccountingConfirmCubit() : super(const AccountingConfirmState());

  void loadInitialState(List<AccountingResultEntity> accountingResults) {
    final Map<String, bool> userStates = {};
    for (final result in accountingResults) {
      userStates[result.userPk] = result.accountingDone;
    }
    emit(AccountingConfirmState(userStates: userStates));
  }

  void toggleUser(String userPk) {
    final currentStates = state.userStates;
    final newStates = Map<String, bool>.from(currentStates);
    newStates[userPk] = !(newStates[userPk] ?? false);
    emit(AccountingConfirmState(userStates: newStates));
  }

  List<AccountingResultEntity> getAccountingResults() {
    return state.userStates.entries
        .map(
          (entry) => AccountingResultEntity(
            userPk: entry.key,
            accountingDone: entry.value,
          ),
        )
        .toList();
  }
}

@freezed
sealed class AccountingConfirmState with _$AccountingConfirmState {
  const AccountingConfirmState._();
  const factory AccountingConfirmState({
    @Default({}) Map<String, bool> userStates,
  }) = _AccountingConfirmState;

  bool hasChanges(List<AccountingResultEntity> originalResults) {
    if (userStates.isEmpty) return false;

    for (final original in originalResults) {
      final current = userStates[original.userPk];
      if (current != original.accountingDone) {
        return true;
      }
    }
    return false;
  }
}
