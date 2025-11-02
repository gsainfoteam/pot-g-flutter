import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/taxi_app_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'taxi_app_cubit.freezed.dart';

@injectable
class TaxiAppCubit extends Cubit<TaxiAppState> {
  final TaxiAppRepository _repository;
  TaxiAppCubit(this._repository) : super(const TaxiAppState.initial());

  Future<void> callTaxi(TaxiAppType type, RouteEntity route) async {
    emit(const TaxiAppState.loading());
    try {
      await _repository.action(type, route);
      emit(const TaxiAppState.success());
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(TaxiAppState.error(errorId));
    }
  }
}

@freezed
sealed class TaxiAppState with _$TaxiAppState {
  const factory TaxiAppState.initial() = _Initial;
  const factory TaxiAppState.loading() = _Loading;
  const factory TaxiAppState.success() = _Success;
  const factory TaxiAppState.error(String errorId) = _Error;
}
