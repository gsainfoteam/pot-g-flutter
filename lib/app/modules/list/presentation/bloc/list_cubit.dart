import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'list_cubit.freezed.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(const ListState());

  void routeChanged(RouteEntity? route) =>
      emit(state.copyWith(route: route, dateOpened: false));
  void dateChanged(DateTime date) =>
      emit(state.copyWith(date: date, pathOpened: false));

  void pathOpenedChanged(bool value) =>
      emit(state.copyWith(pathOpened: value, dateOpened: false));
  void dateOpenedChanged(bool value) =>
      emit(state.copyWith(dateOpened: value, pathOpened: false));
}

@freezed
sealed class ListState with _$ListState {
  const ListState._();

  const factory ListState({
    @Default(false) bool pathOpened,
    @Default(false) bool dateOpened,
    RouteEntity? route,
    DateTime? date,
  }) = _ListState;
}
