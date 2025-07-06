import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'create_cubit.freezed.dart';

class CreateCubit extends Cubit<CreateState> {
  CreateCubit({DateTime? date, RouteEntity? route})
    : super(CreateState(date: date, route: route));

  void routeChanged(RouteEntity route) => emit(state.copyWith(route: route));
  void dateChanged(DateTime date) => emit(state.copyWith(date: date));
  void maxCapacityChanged(int maxCapacity) =>
      emit(state.copyWith(maxCapacity: maxCapacity));
  void startTimeChanged(DateTime startTime) =>
      emit(state.copyWith(startTime: startTime));
  void endTimeChanged(DateTime endTime) =>
      emit(state.copyWith(endTime: endTime));

  void pathOpenedChanged(bool value) =>
      emit(state.copyWith(pathOpened: value, dateOpened: false));
  void dateOpenedChanged(bool value) =>
      emit(state.copyWith(dateOpened: value, pathOpened: false));
}

@freezed
sealed class CreateState with _$CreateState {
  const CreateState._();

  const factory CreateState({
    RouteEntity? route,
    DateTime? date,
    int? maxCapacity,
    DateTime? startTime,
    DateTime? endTime,
    @Default(false) bool pathOpened,
    @Default(false) bool dateOpened,
  }) = _CreateState;

  bool get valid =>
      route != null &&
      date != null &&
      maxCapacity != null &&
      startTime != null &&
      endTime != null;
}
