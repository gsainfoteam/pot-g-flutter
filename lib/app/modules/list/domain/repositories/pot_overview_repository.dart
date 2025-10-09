import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';

abstract class PotOverviewRepository {
  Future<PotOverviewEntity> getPotOverview(String potId);
}
