import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/accounting_result_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_accounting_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'pot_accounting_bloc.freezed.dart';

@injectable
class PotAccountingBloc extends Bloc<PotAccountingEvent, PotAccountingState> {
  final PotAccountingRepository _repository;

  PotAccountingBloc(this._repository)
    : super(const PotAccountingState.initial()) {
    on<_RequestAccounting>(_onRequestAccounting);
    on<_ConfirmAccounting>(_onConfirmAccounting);
  }

  Future<void> _onRequestAccounting(
    _RequestAccounting event,
    Emitter<PotAccountingState> emit,
  ) async {
    emit(const PotAccountingState.loading());
    try {
      await _repository.accounting(event.pot, event.amount, event.targets);
      emit(const PotAccountingState.requestSuccess());
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotAccountingState.error(e.toString()));
    }
  }

  Future<void> _onConfirmAccounting(
    _ConfirmAccounting event,
    Emitter<PotAccountingState> emit,
  ) async {
    emit(const PotAccountingState.loading());
    try {
      await _repository.confirmAccounting(event.pot, event.accountingResults);
      emit(const PotAccountingState.confirmSuccess());
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotAccountingState.error(e.toString()));
    }
  }
}

@freezed
sealed class PotAccountingEvent with _$PotAccountingEvent {
  const factory PotAccountingEvent.requestAccounting(
    PotInfoEntity pot,
    int amount,
    List<PotUserEntity> targets,
  ) = _RequestAccounting;
  const factory PotAccountingEvent.confirmAccounting(
    PotInfoEntity pot,
    List<AccountingResultEntity> accountingResults,
  ) = _ConfirmAccounting;
}

@freezed
sealed class PotAccountingState with _$PotAccountingState {
  const PotAccountingState._();
  const factory PotAccountingState.initial() = _Initial;
  const factory PotAccountingState.loading() = _Loading;
  const factory PotAccountingState.requestSuccess() = _RequestSuccess;
  const factory PotAccountingState.confirmSuccess() = _ConfirmSuccess;
  const factory PotAccountingState.error(String message) = _Error;

  bool get isLoading => switch (this) {
    _Loading() => true,
    _ => false,
  };
  String? get error => switch (this) {
    _Error(:final message) => message,
    _ => null,
  };
}
