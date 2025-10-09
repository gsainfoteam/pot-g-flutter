import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';
import 'package:pot_g/app/modules/list/domain/repositories/pot_overview_repository.dart';

part 'pot_overview_bloc.freezed.dart';

@injectable
class PotOverviewBloc extends Bloc<PotOverviewEvent, PotOverviewState> {
  final PotOverviewRepository _repository;

  PotOverviewBloc(this._repository) : super(const PotOverviewState.loading()) {
    on<_Init>(_onInit);
  }

  Future<void> _onInit(_Init event, Emitter<PotOverviewState> emit) async {
    emit(const PotOverviewState.loading());
    try {
      final overview = await _repository.getPotOverview(event.potId);
      emit(PotOverviewState.loaded(overview));
    } catch (e) {
      emit(PotOverviewState.error(e.toString()));
    }
  }
}

@freezed
sealed class PotOverviewEvent with _$PotOverviewEvent {
  const factory PotOverviewEvent.init(String potId) = _Init;
}

@freezed
sealed class PotOverviewState with _$PotOverviewState {
  const PotOverviewState._();
  const factory PotOverviewState.loading() = _Loading;
  const factory PotOverviewState.loaded(PotOverviewEntity overview) = _Loaded;
  const factory PotOverviewState.error(String message) = _Error;

  PotOverviewEntity? get overview => switch (this) {
    _Loaded(:final overview) => overview,
    _ => null,
  };
  String? get error => switch (this) {
    _Error(:final message) => message,
    _ => null,
  };
}
