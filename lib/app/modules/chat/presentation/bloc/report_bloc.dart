import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';

part 'report_bloc.freezed.dart';

@injectable
class ReportBloc extends Bloc<ReportSubmitEvent, ReportSubmitState> {
  ReportBloc(this._repository) : super(const ReportSubmitState()) {
    on<_Submitted>(_onSubmitted);
  }

  final ReportRepository _repository;

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<ReportSubmitState> emit,
  ) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, error: null, success: false));

    try {
      final reasonPayload = event.reason.requiresDetail
          ? event.reasonDetail!.trim()
          : event.reason.name;

      await _repository.submit(
        pot: event.pot,
        target: event.target,
        reasonKey: reasonPayload,
      );
      emit(state.copyWith(isSubmitting: false, success: true));
    } on ReportException catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e));
    }
  }
}

@freezed
abstract class ReportSubmitEvent with _$ReportSubmitEvent {
  const factory ReportSubmitEvent.submitted({
    required PotInfoEntity pot,
    required PotUserEntity target,
    required ReportReason reason,
    String? reasonDetail,
  }) = _Submitted;
}

@freezed
abstract class ReportSubmitState with _$ReportSubmitState {
  const factory ReportSubmitState({
    @Default(false) bool isSubmitting,
    @Default(false) bool success,
    ReportException? error,
  }) = _ReportSubmitState;
}
