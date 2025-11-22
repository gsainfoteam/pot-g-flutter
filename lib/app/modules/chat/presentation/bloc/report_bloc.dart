import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'report_bloc.freezed.dart';

@injectable
class ReportBloc extends Bloc<ReportSubmitEvent, ReportSubmitState> {
  ReportBloc(this._repository) : super(const ReportSubmitState()) {
    on<_Submit>(_onSubmit, transformer: droppable());
  }

  final ReportRepository _repository;

  Future<void> _onSubmit(_Submit event, Emitter<ReportSubmitState> emit) async {
    emit(state.copyWith(isSubmitting: true, error: null, success: false));

    try {
      final detail = (event.reasonDetail ?? '').trim();
      final reasonPayload = event.reason.requiresDetail
          ? detail
          : event.reason.name;

      await _repository.submit(
        pot: event.pot,
        target: event.target,
        reasonKey: reasonPayload,
      );
      emit(state.copyWith(isSubmitting: false, success: true));
    } on ReportException catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e));
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(
        state.copyWith(
          isSubmitting: false,
          error: ReportException.unknown(e, errorId),
        ),
      );
    }
  }
}

@freezed
abstract class ReportSubmitEvent with _$ReportSubmitEvent {
  const factory ReportSubmitEvent.submit({
    required PotInfoEntity pot,
    required PotUserEntity target,
    required ReportReason reason,
    String? reasonDetail,
  }) = _Submit;
}

@freezed
abstract class ReportSubmitState with _$ReportSubmitState {
  const factory ReportSubmitState({
    @Default(false) bool isSubmitting,
    @Default(false) bool success,
    ReportException? error,
  }) = _SubmitState;
}
