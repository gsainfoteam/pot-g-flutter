import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/repositories/create_pot_repository.dart';
import 'package:pot_g/app/modules/create/data/data_source/remote/create_pot_api.dart';
import 'package:pot_g/app/modules/create/data/model/create_pot_model.dart';

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

    final String potId = await _api.createPot(createPotModel);

    return potId;
  }
}
