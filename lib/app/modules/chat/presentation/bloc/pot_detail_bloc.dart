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

  PotDetailBloc(this._repository) : super(const PotDetailState()) {
    on<_LoadMyPots>(_onLoadMyPots);
  }

  Future<void> _onLoadMyPots(
    _LoadMyPots event,
    Emitter<PotDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final pots = await _repository.getMyPotList();
      emit(
        state.copyWith(
          isLoading: false,
          activePotList: pots.potList,
          archivedPotList: pots.archivedPotList,
        ),
      );
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

@freezed
sealed class PotDetailEvent with _$PotDetailEvent {
  const factory PotDetailEvent.loadMyPots() = _LoadMyPots;
}

@freezed
sealed class PotDetailState with _$PotDetailState {
  const factory PotDetailState({
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<PotDetailModel> activePotList,
    @Default([]) List<PotDetailModel> archivedPotList,
  }) = _State;
}
