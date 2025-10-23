import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/list/domain/exceptions/join_pot_exception.dart';
import 'package:pot_g/app/modules/list/domain/repositories/join_pot_repository.dart';

part 'join_pot_bloc.freezed.dart';

@injectable
class JoinPotBloc extends Bloc<JoinPotEvent, JoinPotState> {
  final JoinPotRepository _repository;

  JoinPotBloc(this._repository) : super(const JoinPotState.initial()) {
    on<_Join>(_onJoin);
  }

  Future<void> _onJoin(_Join event, Emitter<JoinPotState> emit) async {
    emit(const JoinPotState.loading());
    try {
      await _repository.joinPot(event.potId);
      emit(JoinPotState.success(event.potId));
    } on JoinPotException catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(JoinPotState.error(e));
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(JoinPotState.error(JoinPotException.unknown(e)));
    }
  }
}

@freezed
sealed class JoinPotEvent with _$JoinPotEvent {
  const factory JoinPotEvent.join(String potId) = _Join;
}

@freezed
sealed class JoinPotState with _$JoinPotState {
  const factory JoinPotState.initial() = _Initial;
  const factory JoinPotState.loading() = _Loading;
  const factory JoinPotState.success(String potId) = _Success;
  const factory JoinPotState.error(JoinPotException err) = _Error;
}
