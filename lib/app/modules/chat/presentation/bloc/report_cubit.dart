import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';

part 'report_cubit.freezed.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  static const int maxReasonLength = 200;

  ReportCubit() : super(const ReportState());

  void targetChanged(PotUserEntity? target) {
    emit(state.copyWith(target: target));
  }

  void reasonChanged(ReportReason? reason) {
    emit(state.copyWith(reason: reason));
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
  }) = _ReportState;

  bool get canSubmit {
    if (target == null || reason == null) return false;
    if (reason == ReportReason.other) {
      return reasonDetail != null &&
          reasonDetail!.trim().isNotEmpty &&
          reasonDetail!.trim().length <= ReportCubit.maxReasonLength;
    }
    return true;
  }
}
