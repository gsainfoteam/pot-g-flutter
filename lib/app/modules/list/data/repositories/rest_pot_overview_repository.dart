import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/list/data/data_source/remote/pot_overview_api.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';
import 'package:pot_g/app/modules/list/domain/repositories/pot_overview_repository.dart';

@Injectable(as: PotOverviewRepository)
class RestPotOverviewRepository implements PotOverviewRepository {
  final PotOverviewApi _api;

  RestPotOverviewRepository(this._api);

  @override
  Future<PotOverviewEntity> getPotOverview(String potId) async {
    return await _api.getPotOverview(potId);
  }
}
