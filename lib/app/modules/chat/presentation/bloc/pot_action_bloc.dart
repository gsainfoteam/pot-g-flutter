import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/departure_time_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/kick_user_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/leave_pot_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_action_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'pot_action_bloc.freezed.dart';

@injectable
class PotActionBloc extends Bloc<PotActionEvent, PotActionState> {
  final PotActionRepository _repository;

  PotActionBloc(this._repository) : super(const PotActionState.initial()) {
    on<_SetDepartureTime>(_onSetDepartureTime);
    on<_LeavePot>(_onLeavePot);
    on<_KickUser>(_onKickUser);
  }

  Future<void> _onSetDepartureTime(
    _SetDepartureTime event,
    Emitter<PotActionState> emit,
  ) async {
    emit(const PotActionState.loading());
    try {
      final s = event.pot.startsAt;
      final adjustedDate = event.date.copyWith(
        year: s.year,
        month: s.month,
        day: s.day,
      );
      await _repository.setDepartureTime(
        event.pot,
        adjustedDate.isBefore(s)
            ? adjustedDate.add(Duration(days: 1))
            : adjustedDate,
      );
      emit(const PotActionState.success());
    } on DepartureTimeException catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotActionState.departureTimeError(e));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(
        PotActionState.departureTimeError(DepartureTimeException.unknown(e)),
      );
    }
  }

  Future<void> _onLeavePot(
    _LeavePot event,
    Emitter<PotActionState> emit,
  ) async {
    emit(const PotActionState.loading());
    try {
      await _repository.leavePot(event.pot);
      emit(const PotActionState.success());
    } on LeavePotException catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotActionState.leavePotError(e));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotActionState.leavePotError(LeavePotException.unknown(e)));
    }
  }

  Future<void> _onKickUser(
    _KickUser event,
    Emitter<PotActionState> emit,
  ) async {
    emit(const PotActionState.loading());
    try {
      await _repository.kickUser(event.pot, event.user);
      emit(const PotActionState.success());
    } on KickUserException catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotActionState.kickUserError(e));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PotActionState.kickUserError(KickUserException.unknown(e)));
    }
  }
}

@freezed
sealed class PotActionEvent with _$PotActionEvent {
  const factory PotActionEvent.setDepartureTime(
    PotInfoEntity pot,
    DateTime date,
  ) = _SetDepartureTime;
  const factory PotActionEvent.leavePot(PotInfoEntity pot) = _LeavePot;
  const factory PotActionEvent.kickUser(PotInfoEntity pot, PotUserEntity user) =
      _KickUser;
}

@freezed
sealed class PotActionState with _$PotActionState {
  const PotActionState._();
  const factory PotActionState.initial() = _Initial;
  const factory PotActionState.loading() = _Loading;
  const factory PotActionState.success() = _Success;
  const factory PotActionState.departureTimeError(DepartureTimeException err) =
      _DepartureTimeError;
  const factory PotActionState.leavePotError(LeavePotException err) =
      _LeavePotError;
  const factory PotActionState.kickUserError(KickUserException err) =
      _KickUserError;

  bool get isLoading => switch (this) {
    _Loading() => true,
    _ => false,
  };
  DepartureTimeException? get departureTimeError => switch (this) {
    _DepartureTimeError(:final err) => err,
    _ => null,
  };
  LeavePotException? get leavePotError => switch (this) {
    _LeavePotError(:final err) => err,
    _ => null,
  };
  KickUserException? get kickUserError => switch (this) {
    _KickUserError(:final err) => err,
    _ => null,
  };
}
