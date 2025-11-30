import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/repositories/create_pot_repository.dart';
import 'package:pot_g/app/modules/create/data/data_source/remote/create_pot_api.dart';
import 'package:pot_g/app/modules/create/data/model/create_pot_model.dart';
import 'package:pot_g/app/modules/create/data/model/create_pot_result_model.dart';
import 'package:pot_g/app/modules/create/domain/exceptions/create_pot_exception.dart';

@Injectable(as: CreatePotRepository)
class RestCreatePotRepository implements CreatePotRepository {
  final CreatePotApi _api;

  RestCreatePotRepository(this._api);

  @override
  Future<String> createPot({
    required String routeId,
    required DateTime startsAt,
    required DateTime endsAt,
    required int maxCount,
  }) async {
    final createPotModel = CreatePotModel(
      routeId: routeId,
      startsAt: startsAt,
      endsAt: endsAt,
      maxCount: maxCount,
    );

    try {
      final result = await _api.createPot(createPotModel);
      switch (result.result) {
        case CreatePotResult.ok:
          final id = result.id;
          if (id == null || id.isEmpty) {
            throw CreatePotException.networkError('Invalid id');
          }
          return id;
        case CreatePotResult.invalidCapacity:
          throw CreatePotException.invalidCapacity();
        case CreatePotResult.departureAvailableBeforeNow:
          throw CreatePotException.departureAvailableBeforeNow();
        case CreatePotResult.invalidDepartureAvailableTime:
          throw CreatePotException.invalidDepartureAvailableTime();
        case CreatePotResult.tooFarDepartureAvailableTime:
          throw CreatePotException.tooFarDepartureAvailableTime();
      }
    } on DioException catch (e) {
      throw CreatePotException.networkError(e.error.toString());
    } on ArgumentError catch (e) {
      throw CreatePotException.unknownResponse(e.invalidValue.toString());
    }
  }
}
