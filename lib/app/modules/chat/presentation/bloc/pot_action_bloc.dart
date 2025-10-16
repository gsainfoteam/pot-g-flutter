import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_action_repository.dart';

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
    } catch (e) {
      emit(PotActionState.error(e.toString()));
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
    } catch (e) {
      emit(PotActionState.error(e.toString()));
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
    } catch (e) {
      emit(PotActionState.error(e.toString()));
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
  const factory PotActionState.error(String message) = _Error;

  bool get isLoading => switch (this) {
    _Loading() => true,
    _ => false,
  };
  String? get error => switch (this) {
    _Error(:final message) => message,
    _ => null,
  };
}
