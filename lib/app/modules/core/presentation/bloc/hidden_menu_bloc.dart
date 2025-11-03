import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/enums/hidden_menu_level.dart';
import 'package:pot_g/app/modules/core/domain/repositories/hidden_menu_repository.dart';

part 'hidden_menu_bloc.freezed.dart';

@injectable
class HiddenMenuBloc extends Bloc<HiddenMenuEvent, HiddenMenuState> {
  final HiddenMenuRepository _repository;

  HiddenMenuBloc(this._repository) : super(const HiddenMenuState.initial()) {
    on<_Init>(_onInit);
    on<_TryEnable>(_onTryEnable);
    on<_Disable>(_onDisable);
  }

  Future<void> _onInit(_Init event, Emitter<HiddenMenuState> emit) async {
    final level = await _repository.getLevel();
    if (level == null) {
      emit(const HiddenMenuState.disabled());
      return;
    }
    emit(HiddenMenuState.enabled(level));
  }

  Future<void> _onTryEnable(
    _TryEnable event,
    Emitter<HiddenMenuState> emit,
  ) async {
    final level = await _repository.tryEnable(event.secret);
    if (level == null) {
      emit(const HiddenMenuState.disabled());
      return;
    }
    emit(HiddenMenuState.enabled(level));
  }

  Future<void> _onDisable(_Disable event, Emitter<HiddenMenuState> emit) async {
    await _repository.disable();
    emit(const HiddenMenuState.disabled());
  }
}

@freezed
sealed class HiddenMenuEvent with _$HiddenMenuEvent {
  const factory HiddenMenuEvent.init() = _Init;
  const factory HiddenMenuEvent.tryEnable(String secret) = _TryEnable;
  const factory HiddenMenuEvent.disable() = _Disable;
}

@freezed
sealed class HiddenMenuState with _$HiddenMenuState {
  const HiddenMenuState._();
  const factory HiddenMenuState.initial() = _Initial;
  const factory HiddenMenuState.enabled(HiddenMenuLevel level) = _Enabled;
  const factory HiddenMenuState.disabled() = _Disabled;

  HiddenMenuLevel? get level => switch (this) {
    _Enabled(:final level) => level,
    _ => null,
  };
}
