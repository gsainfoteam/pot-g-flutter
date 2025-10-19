import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/domain/repositories/pot_list_repository.dart';

part 'pot_list_bloc.freezed.dart';

@Injectable()
class PotListBloc extends Bloc<PotListEvent, PotListState> {
  final PotListRepository _repository;

  _Search? _search;

  PotListBloc(this._repository) : super(_State()) {
    on<PotListEvent>((event, emit) {
      switch (event) {
        case _Search():
          return _onSearch(event, emit);
        case _LoadMore():
          return _onLoadMore(event, emit);
      }
    }, transformer: droppable());
  }

  Future<void> _onSearch(_Search event, Emitter<PotListState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      _search = event;
      final pots = await _repository.getPotList(
        date: event.date,
        route: event.route,
      );
      emit(state.copyWith(pots: pots, isLoading: false));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<PotListState> emit) async {
    if (_search == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      final pots = await _repository.getPotList(
        date: _search!.date,
        route: _search!.route,
        offset: state.pots.length,
      );
      emit(state.copyWith(pots: [...state.pots, ...pots], isLoading: false));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}

@freezed
sealed class PotListEvent with _$PotListEvent {
  const factory PotListEvent.search({DateTime? date, RouteEntity? route}) =
      _Search;
  const factory PotListEvent.loadMore() = _LoadMore;
}

@freezed
sealed class PotListState with _$PotListState {
  const factory PotListState({
    @Default([]) List<PotSummaryEntity> pots,
    @Default(false) bool isLoading,
    String? error,
  }) = _State;
}
