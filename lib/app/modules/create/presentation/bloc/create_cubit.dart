import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/date_time_utils.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'create_cubit.freezed.dart';

@injectable
class CreateCubit extends Cubit<CreateState> {
  CreateCubit() : super(const CreateState());

  void routeChanged(RouteEntity route) => emit(state.copyWith(route: route));

  void dateChanged(DateTime date) {
    // 오늘 날짜인 경우 시작 시간이 현재 시간보다 이전이면 초기화
    if (date.isToday && state.startTime != null) {
      final currentTime = DateTimeUtils.getCurrentTime();
      final startDateTime = date.combineWithTime(state.startTime!);

      if (startDateTime.isBefore(currentTime)) {
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
      final currentTime = DateTimeUtils.getCurrentTime();
      final startDateTime = state.date!.combineWithTime(startTime);

      if (startDateTime.isBefore(currentTime)) {
        return; // 무시
      }
    }

    // 시작 시간이 종료 시간보다 늦으면 종료 시간 초기화
    if (state.endTime != null && state.date != null) {
      final startDateTime = state.date!.combineWithTime(startTime);
      final endDateTime = state.date!.combineWithTime(state.endTime!);

      if (startDateTime.isAfter(endDateTime) ||
          startDateTime.isAtSameMomentAs(endDateTime)) {
        emit(state.copyWith(startTime: startTime, endTime: null));
        return;
      }
    }

    emit(state.copyWith(startTime: startTime));
  }

  void endTimeChanged(DateTime endTime) {
    // 시작 시간이 설정되어 있으면 종료 시간이 시작 시간보다 늦어야 함
    if (state.startTime != null && state.date != null) {
      final startDateTime = state.date!.combineWithTime(state.startTime!);
      final endDateTime = state.date!.combineWithTime(endTime);

      if (endDateTime.isBefore(startDateTime) ||
          endDateTime.isAtSameMomentAs(startDateTime)) {
        return; // 무시
      }
    }

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
