import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/repositories/app_version_repository.dart';
import 'package:pub_semver/pub_semver.dart';

part 'app_version_bloc.freezed.dart';

@injectable
class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionRepository _appVersionRepository;

  AppVersionBloc(this._appVersionRepository)
    : super(const AppVersionState.initial()) {
    on<_Init>(_onInit, transformer: droppable());
  }

  Future<void> _onInit(
    AppVersionEvent event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(const AppVersionState.loading());
    try {
      emit(
        AppVersionState.data(
          currentVersion: await _appVersionRepository.getCurrentVersion(),
          latestVersion: await _appVersionRepository.getLatestVersion(),
          minVersion: await _appVersionRepository.getMinVersion(),
          updateAvailable: await _appVersionRepository.updateAvailable(),
          updateRequired: await _appVersionRepository.updateRequired(),
        ),
      );
    } catch (e) {
      emit(AppVersionState.error(e.toString()));
    }
  }
}

@freezed
sealed class AppVersionEvent with _$AppVersionEvent {
  const factory AppVersionEvent.init() = _Init;
}

@freezed
sealed class AppVersionState with _$AppVersionState {
  const factory AppVersionState.initial() = _Initial;
  const factory AppVersionState.loading() = _Loading;
  const factory AppVersionState.error(String message) = AppVersionStateError;
  const factory AppVersionState.data({
    required Version currentVersion,
    required Version latestVersion,
    required Version minVersion,
    required bool updateAvailable,
    required bool updateRequired,
  }) = AppVersionStateData;
}
