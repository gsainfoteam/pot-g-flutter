import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/main/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/main/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/main/domain/repositories/pot_list_repository.dart';

@Injectable(as: PotListRepository)
class MockPotListRepository implements PotListRepository {
  @override
  Future<List<PotEntity>> getPotList({
    DateTime? date,
    RouteEntity? route,
  }) async {
    return [];
  }
}
