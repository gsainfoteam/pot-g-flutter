import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';

part 'report_bloc.freezed.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc(this._repository, @factoryParam this._pot)
    : super(const ReportState()) {
    on<_TargetChanged>(_onTargetChanged);
    on<_ReasonChanged>(_onReasonChanged);
    on<_TargetSelectorToggled>(
      (event, emit) => emit(state.copyWith(targetSelectorOpen: event.isOpen)),
    );
    on<_ReasonSelectorToggled>(
      (event, emit) => emit(state.copyWith(reasonSelectorOpen: event.isOpen)),
    );
    on<_Submitted>(_onSubmitted);
  }

  final ReportRepository _repository;
  final PotInfoEntity _pot;

  void _onTargetChanged(_TargetChanged event, Emitter<ReportState> emit) {
    emit(
      state.copyWith(
        target: event.target,
        submissionSuccess: false,
        error: null,
      ),
    );
  }

  void _onReasonChanged(_ReasonChanged event, Emitter<ReportState> emit) {
    emit(
      state.copyWith(
        reasonKey: event.reasonKey,
        submissionSuccess: false,
        error: null,
      ),
    );
  }

  Future<void> _onSubmitted(_Submitted event, Emitter<ReportState> emit) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await _repository.submit(
        pot: _pot,
        target: state.target!,
        reasonKey: state.reasonKey!,
      );
      emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
    } on ReportException catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e));
    }
  }
}

@freezed
sealed class ReportEvent with _$ReportEvent {
  const factory ReportEvent.targetChanged(PotUserEntity? target) =
      _TargetChanged;
  const factory ReportEvent.reasonChanged(String? reasonKey) = _ReasonChanged;
  const factory ReportEvent.targetSelectorToggled(bool isOpen) =
      _TargetSelectorToggled;
  const factory ReportEvent.reasonSelectorToggled(bool isOpen) =
      _ReasonSelectorToggled;
  const factory ReportEvent.submitted() = _Submitted;
}

@freezed
sealed class ReportState with _$ReportState {
  const ReportState._();

  const factory ReportState({
    PotUserEntity? target,
    String? reasonKey,
    @Default(true) bool targetSelectorOpen,
    @Default(false) bool reasonSelectorOpen,
    @Default(false) bool isSubmitting,
    @Default(false) bool submissionSuccess,
    ReportException? error,
  }) = _ReportState;

  bool get canSubmit => target != null && reasonKey != null && !isSubmitting;
}
