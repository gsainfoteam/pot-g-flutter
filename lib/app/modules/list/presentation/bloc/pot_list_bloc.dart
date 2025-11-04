import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
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
    on<_Search>(_onSearch, transformer: restartable());
    on<_LoadMore>(_onLoadMore, transformer: droppable());
  }

  Future<void> _onSearch(_Search event, Emitter<PotListState> emit) async {
    _search = event;
    emit(
      state.copyWith(pots: [], isLoading: true, endReached: false, error: null),
    );
    await _load(emit);
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<PotListState> emit) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<PotListState> emit) async {
    if (_search == null) return;
    if (state.endReached) return;
    emit(state.copyWith(isLoading: true));
    try {
      final pots = await _repository.getPotList(
        date: _search!.date,
        route: _search!.route,
        offset: state.pots.length,
      );
      emit(
        state.copyWith(
          pots: [...state.pots, ...pots].sorted(
            (a, b) =>
                (a.total == a.current ? 1 : 0) - (b.total == b.current ? 1 : 0),
          ),
          isLoading: false,
          endReached: pots.length < 100,
        ),
      );
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
    @Default(false) bool endReached,
    String? error,
  }) = _State;
}
