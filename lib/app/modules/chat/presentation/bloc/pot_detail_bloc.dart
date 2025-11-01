import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_detail_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/data/models/pot_detail_model.dart';

part 'pot_detail_bloc.freezed.dart';

@Injectable()
class PotDetailBloc extends Bloc<PotDetailEvent, PotDetailState> {
  final PotDetailRepository _repository;

  PotDetailBloc(this._repository) : super(const PotDetailState.initial()) {
    on<_LoadMyPots>(_onLoadMyPots, transformer: restartable());
  }

  Future<void> _onLoadMyPots(
    _LoadMyPots event,
    Emitter<PotDetailState> emit,
  ) async {
    emit(const _Loading());
    return emit.forEach(
      _repository.getMyPotList(),
      onData: (pots) => _Loaded(pots.potList, pots.archivedPotList),
      onError: (error, stackTrace) {
        final errorId = L.e(error, stackTrace);
        return _Error(error, errorId);
      },
    );
  }
}

@freezed
sealed class PotDetailEvent with _$PotDetailEvent {
  const factory PotDetailEvent.loadMyPots() = _LoadMyPots;
}

@freezed
sealed class PotDetailState with _$PotDetailState {
  const PotDetailState._();

  const factory PotDetailState.initial() = _Initial;
  const factory PotDetailState.loading() = _Loading;
  const factory PotDetailState.error(Object error, String errorId) = _Error;
  const factory PotDetailState.loaded(
    List<PotDetailModel> activePotList,
    List<PotDetailModel> archivedPotList,
  ) = _Loaded;

  List<PotDetailModel> get activePotList => switch (this) {
    _Loaded(:final activePotList) => activePotList,
    _ => [],
  };
  List<PotDetailModel> get archivedPotList => switch (this) {
    _Loaded(:final archivedPotList) => archivedPotList,
    _ => [],
  };

  bool get isLoading => switch (this) {
    _Loading() => true,
    _ => false,
  };
}
