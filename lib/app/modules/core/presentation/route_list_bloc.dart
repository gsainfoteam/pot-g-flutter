import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/domain/repositories/route_list_repository.dart';

part 'route_list_bloc.freezed.dart';

@injectable
class RouteListBloc extends Bloc<RouteListEvent, RouteListState> {
  final RouteListRepository _repository;

  RouteListBloc(this._repository) : super(const RouteListState.initial()) {
    on<_Search>(_onSearch);
  }

  Future<void> _onSearch(_Search event, Emitter<RouteListState> emit) async {
    emit(const RouteListState.loading());
    final routes = await _repository.getRouteList();
    emit(RouteListState.loaded(routes));
  }
}

@freezed
sealed class RouteListEvent with _$RouteListEvent {
  const factory RouteListEvent.search() = _Search;
}

@freezed
sealed class RouteListState with _$RouteListState {
  const RouteListState._();

  const factory RouteListState.initial() = _Initial;
  const factory RouteListState.loading() = _Loading;
  const factory RouteListState.loaded(List<RouteEntity> routes) = _Loaded;
  const factory RouteListState.error(String message) = _Error;

  List<RouteEntity> get routes => switch (this) {
    _Loaded(:final routes) => routes,
    _ => [],
  };
}
