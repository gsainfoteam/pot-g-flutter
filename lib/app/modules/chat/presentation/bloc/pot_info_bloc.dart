import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';

part 'pot_info_bloc.freezed.dart';

@injectable
class PotInfoBloc extends Bloc<PotInfoEvent, PotInfoState> {
  final PotInfoRepository _repository;

  PotInfoBloc(this._repository) : super(const PotInfoState.loading()) {
    on<_Init>(_onInit);
    on<_SetDepartureTime>(_onSetDepartureTime);
    on<_LeavePot>(_onLeavePot);
    on<_KickUser>(_onKickUser);
    on<_Accounting>(_onAccounting);
  }

  Future<void> _onInit(_Init event, Emitter<PotInfoState> emit) async {
    return emit.forEach(
      _repository.getPotInfoStream(event.pot),
      onData: (pot) => PotInfoState.loaded(pot),
      onError: (error, stackTrace) => PotInfoState.error(error.toString()),
    );
  }

  Future<void> _onSetDepartureTime(
    _SetDepartureTime event,
    Emitter<PotInfoState> emit,
  ) async {
    if (state.pot == null) return;
    try {
      await _repository.setDepartureTime(state.pot!, event.date);
    } catch (e) {
      emit(PotInfoState.error(e.toString()));
    }
  }

  Future<void> _onLeavePot(_LeavePot event, Emitter<PotInfoState> emit) async {
    if (state.pot == null) return;
    try {
      await _repository.leavePot(state.pot!);
    } catch (e) {
      emit(PotInfoState.error(e.toString()));
    }
  }

  Future<void> _onKickUser(_KickUser event, Emitter<PotInfoState> emit) async {
    if (state.pot == null) return;
    try {
      await _repository.kickUser(state.pot!, event.user);
    } catch (e) {
      emit(PotInfoState.error(e.toString()));
    }
  }

  Future<void> _onAccounting(
    _Accounting event,
    Emitter<PotInfoState> emit,
  ) async {
    if (state.pot == null) return;
    final pot = state.pot!;
    try {
      emit(const PotInfoState.loading());
      await _repository.accounting(pot, event.amount, event.targets);
      emit(const PotInfoState.accountingSuccess());
    } catch (e) {
      emit(PotInfoState.error(e.toString()));
    } finally {
      emit(PotInfoState.loaded(pot));
    }
  }
}

@freezed
sealed class PotInfoEvent with _$PotInfoEvent {
  const factory PotInfoEvent.init(PotIdEntity pot) = _Init;
  const factory PotInfoEvent.setDepartureTime(DateTime date) =
      _SetDepartureTime;
  const factory PotInfoEvent.leavePot() = _LeavePot;
  const factory PotInfoEvent.kickUser(PotUserEntity user) = _KickUser;
  const factory PotInfoEvent.accounting(
    int amount,
    List<PotUserEntity> targets,
  ) = _Accounting;
}

@freezed
sealed class PotInfoState with _$PotInfoState {
  const PotInfoState._();
  const factory PotInfoState.loading() = _Loading;
  const factory PotInfoState.loaded(PotInfoEntity pot) = _Loaded;
  const factory PotInfoState.accountingSuccess() = AccountingSuccess;
  const factory PotInfoState.error(String message) = _Error;

  PotInfoEntity? get pot => switch (this) {
    _Loaded(:final pot) => pot,
    _ => null,
  };
  String? get error => switch (this) {
    _Error(:final message) => message,
    _ => null,
  };
}
