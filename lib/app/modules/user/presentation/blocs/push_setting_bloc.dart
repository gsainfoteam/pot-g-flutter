import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/user/domain/entities/push_setting_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/push_setting_repository.dart';

part 'push_setting_bloc.freezed.dart';

@injectable
class PushSettingBloc extends Bloc<PushSettingEvent, PushSettingState> {
  final PushSettingRepository _pushSettingRepository;

  PushSettingBloc(this._pushSettingRepository)
    : super(const PushSettingState.initial()) {
    on<_Load>(_onLoad);
    on<_Update>(_onUpdate);
  }

  Future<void> _onLoad(
    PushSettingEvent event,
    Emitter<PushSettingState> emit,
  ) async {
    emit(const PushSettingState.loading());
    try {
      final user = await _pushSettingRepository.getUser();
      emit(PushSettingState.loaded(user.pushSetting));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PushSettingState.error(e.toString()));
    }
  }

  Future<void> _onUpdate(
    PushSettingEvent event,
    Emitter<PushSettingState> emit,
  ) async {
    try {
      final updated = await _pushSettingRepository.updatePush(
        (event as _Update).pushSetting,
      );
      emit(PushSettingState.loaded(updated));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PushSettingState.error(e.toString()));
    }
  }
}

@freezed
sealed class PushSettingEvent with _$PushSettingEvent {
  const factory PushSettingEvent.load() = _Load;
  const factory PushSettingEvent.update(PushSettingEntity pushSetting) =
      _Update;
}

@freezed
sealed class PushSettingState with _$PushSettingState {
  const PushSettingState._();

  const factory PushSettingState.initial() = _Initial;
  const factory PushSettingState.loading() = _Loading;
  const factory PushSettingState.loaded(PushSettingEntity pushSetting) =
      _Loaded;
  const factory PushSettingState.error(String message) = _Error;
}
