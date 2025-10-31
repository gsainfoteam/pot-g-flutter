import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/repositories/create_pot_repository.dart';
import 'package:pot_g/app/modules/create/domain/exceptions/create_pot_exception.dart';

part 'create_pot_bloc.freezed.dart';

@Injectable()
class CreatePotBloc extends Bloc<CreatePotEvent, CreatePotState> {
  final CreatePotRepository _repository;

  CreatePotBloc(this._repository) : super(const CreatePotState.initial()) {
    on<_Create>(_onCreate);
  }

  Future<void> _onCreate(_Create event, Emitter<CreatePotState> emit) async {
    emit(const CreatePotState.loading());
    try {
      final potId = await _repository.createPot(
        routeId: event.routeId,
        startsAt: event.startsAt,
        endsAt: event.endsAt,
        maxCount: event.maxCount,
      );

      emit(CreatePotState.success(potId));
    } on CreatePotException catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(CreatePotState.error(e, errorId));
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(CreatePotState.error(CreatePotException.unknown(e), errorId));
    }
  }
}

@freezed
sealed class CreatePotEvent with _$CreatePotEvent {
  const factory CreatePotEvent.create({
    required String routeId,
    required DateTime startsAt,
    required DateTime endsAt,
    required int maxCount,
  }) = _Create;
}

@freezed
sealed class CreatePotState with _$CreatePotState {
  const CreatePotState._();

  const factory CreatePotState.initial() = _Initial;
  const factory CreatePotState.loading() = _Loading;
  const factory CreatePotState.success(String potId) = _Success;
  const factory CreatePotState.error(CreatePotException error, String errorId) =
      _Error;

  bool get isLoading => switch (this) {
    _Loading() => true,
    _ => false,
  };
}
