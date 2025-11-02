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
    on<_CheckOsPermission>(_onCheckOsPermission);
    on<_OpenAppSettings>(_onOpenAppSettings);
  }

  Future<void> _onLoad(_Load event, Emitter<PushSettingState> emit) async {
    emit(const PushSettingState.loading());
    try {
      final user = await _pushSettingRepository.getUser();
      final isOsNotificationEnabled = await _pushSettingRepository
          .checkOsNotificationPermission();
      emit(
        PushSettingState.loaded(
          user.pushSetting,
          isOsNotificationEnabled: isOsNotificationEnabled,
        ),
      );
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PushSettingState.error(e.toString()));
    }
  }

  Future<void> _onUpdate(_Update event, Emitter<PushSettingState> emit) async {
    try {
      final updated = await _pushSettingRepository.updatePush(
        event.pushSetting,
      );
      final currentState = state;
      if (currentState is _Loaded) {
        emit(
          PushSettingState.loaded(
            updated,
            isOsNotificationEnabled: currentState.isOsNotificationEnabled,
          ),
        );
      } else {
        final isOsNotificationEnabled = await _pushSettingRepository
            .checkOsNotificationPermission();
        emit(
          PushSettingState.loaded(
            updated,
            isOsNotificationEnabled: isOsNotificationEnabled,
          ),
        );
      }
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(PushSettingState.error(e.toString()));
    }
  }

  Future<void> _onCheckOsPermission(
    _CheckOsPermission event,
    Emitter<PushSettingState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final isOsNotificationEnabled = await _pushSettingRepository
          .checkOsNotificationPermission();
      emit(
        PushSettingState.loaded(
          currentState.pushSetting,
          isOsNotificationEnabled: isOsNotificationEnabled,
        ),
      );
    }
  }

  Future<void> _onOpenAppSettings(
    _OpenAppSettings event,
    Emitter<PushSettingState> emit,
  ) async {
    await _pushSettingRepository.openAppSettings();
  }
}

@freezed
sealed class PushSettingEvent with _$PushSettingEvent {
  const factory PushSettingEvent.load() = _Load;
  const factory PushSettingEvent.update(PushSettingEntity pushSetting) =
      _Update;
  const factory PushSettingEvent.checkOsPermission() = _CheckOsPermission;
  const factory PushSettingEvent.openAppSettings() = _OpenAppSettings;
}

@freezed
sealed class PushSettingState with _$PushSettingState {
  const PushSettingState._();

  const factory PushSettingState.initial() = _Initial;
  const factory PushSettingState.loading() = _Loading;
  const factory PushSettingState.loaded(
    PushSettingEntity pushSetting, {
    @Default(true) bool isOsNotificationEnabled,
  }) = _Loaded;
  const factory PushSettingState.error(String message) = _Error;
}
