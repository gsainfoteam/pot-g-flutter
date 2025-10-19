import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'create_cubit.freezed.dart';

@injectable
class CreateCubit extends Cubit<CreateState> {
  CreateCubit() : super(const CreateState());

  void routeChanged(RouteEntity route) => emit(state.copyWith(route: route));

  void dateChanged(DateTime date) {
    // 오늘 날짜인 경우 시작 시간이 현재 시간보다 이전이면 초기화
    if (date.isToday && state.startTime != null) {
      final startDateTime = date.combineWithTime(state.startTime!);

      if (startDateTime.isBefore(DateTime.now())) {
        emit(state.copyWith(date: date, startTime: null, endTime: null));
        return;
      }
    }

    emit(state.copyWith(date: date));
  }

  void maxCapacityChanged(int maxCapacity) =>
      emit(state.copyWith(maxCapacity: maxCapacity));

  void startTimeChanged(DateTime startTime) {
    // 오늘 날짜인 경우 시작 시간이 현재 시간보다 이전이면 무시
    if (state.date?.isToday ?? false) {
      final startDateTime = state.date!.combineWithTime(startTime);

      if (startDateTime.isBefore(DateTime.now())) {
        return; // 무시
      }
    }

    emit(state.copyWith(startTime: startTime));
  }

  void endTimeChanged(DateTime endTime) {
    emit(state.copyWith(endTime: endTime));
  }

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
