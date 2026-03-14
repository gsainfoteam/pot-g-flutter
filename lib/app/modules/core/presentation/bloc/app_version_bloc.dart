import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/entities/version_info_entity.dart';
import 'package:pot_g/app/modules/core/domain/repositories/app_version_repository.dart';

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
      final versionInfo = await _appVersionRepository.getVersionInfo();
      emit(AppVersionState.data(versionInfo));
    } catch (e, stackTrace) {
      emit(AppVersionState.error(L.e(e, stackTrace)));
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
  const factory AppVersionState.error(String errorId) = AppVersionStateError;
  const factory AppVersionState.data(VersionInfoEntity versionInfo) =
      AppVersionStateData;
}
