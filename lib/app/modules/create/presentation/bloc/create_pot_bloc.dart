import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';
import 'package:pot_g/app/modules/core/domain/repositories/create_pot_repository.dart';

part 'create_pot_bloc.freezed.dart';

@Injectable()
class CreatePotBloc extends Bloc<CreatePotEvent, CreatePotState> {
  final CreatePotRepository _repository;

  CreatePotBloc(this._repository) : super(const CreatePotState()) {
    on<_Create>(_onCreate);
  }

  Future<void> _onCreate(_Create event, Emitter<CreatePotState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final potResponse = await _repository.createPot(
        routeId: event.potData.route.id,
        startsAt: event.potData.startsAt,
        endsAt: event.potData.endsAt,
        maxCount: event.potData.total,
      );

      final potId = json.decode(potResponse)['id'];

      emit(state.copyWith(isLoading: false, createdPotId: potId));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

@freezed
sealed class CreatePotEvent with _$CreatePotEvent {
  const factory CreatePotEvent.create({required PotSummaryEntity potData}) =
      _Create;
}

@freezed
sealed class CreatePotState with _$CreatePotState {
  const factory CreatePotState({
    @Default(false) bool isLoading,
    String? error,
    String? createdPotId,
  }) = _State;
}
