import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/taxi_app_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

@injectable
class TaxiAppCubit extends Cubit<void> {
  final TaxiAppRepository _repository;
  TaxiAppCubit(this._repository) : super(null);

  Future<void> callTaxi(TaxiAppType type, RouteEntity route) async {
    try {
      await _repository.callTaxi(type, route);
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
    }
  }
}
