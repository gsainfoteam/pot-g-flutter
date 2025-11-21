import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';

part 'report_cubit.freezed.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  static const int maxReasonLength = 200;

  ReportCubit(this._repository, @factoryParam this._pot)
    : super(const ReportState());

  final ReportRepository _repository;
  final PotInfoEntity _pot;

  void targetChanged(PotUserEntity? target) {
    emit(state.copyWith(target: target, submissionSuccess: false, error: null));
  }

  void reasonChanged(ReportReason? reason) {
    emit(
      state.copyWith(
        reason: reason,
        reasonDetail: null,
        submissionSuccess: false,
        error: null,
      ),
    );
  }

  void reasonDetailChanged(String detail) {
    emit(state.copyWith(reasonDetail: detail));
  }

  void targetSelectorToggled(bool isOpen) {
    emit(state.copyWith(targetSelectorOpen: isOpen));
  }

  void reasonSelectorToggled(bool isOpen) {
    emit(state.copyWith(reasonSelectorOpen: isOpen));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      final reasonPayload = state.reason == ReportReason.other
          ? state.reasonDetail!.trim()
          : state.reason!.key;
      await _repository.submit(
        pot: _pot,
        target: state.target!,
        reasonKey: reasonPayload,
      );
      emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
    } on ReportException catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e));
    }
  }
}

@freezed
abstract class ReportState with _$ReportState {
  const ReportState._();

  const factory ReportState({
    PotUserEntity? target,
    ReportReason? reason,
    String? reasonDetail,
    @Default(true) bool targetSelectorOpen,
    @Default(false) bool reasonSelectorOpen,
    @Default(false) bool isSubmitting,
    @Default(false) bool submissionSuccess,
    ReportException? error,
  }) = _ReportState;

  bool get canSubmit {
    if (target == null || reason == null || isSubmitting) return false;
    if (reason == ReportReason.other) {
      return reasonDetail != null &&
          reasonDetail!.trim().isNotEmpty &&
          reasonDetail!.trim().length <= ReportCubit.maxReasonLength;
    }
    return true;
  }
}
