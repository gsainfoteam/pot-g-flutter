import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/main/data/models/pot_model.dart';
import 'package:pot_g/app/modules/main/data/models/route_model.dart';
import 'package:pot_g/app/modules/main/data/models/stop_model.dart';
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
    return [
      PotModel(
        id: '1',
        route: RouteModel(
          id: '1',
          from: StopModel(id: '1', name: '유스퀘어'),
          to: StopModel(id: '2', name: '지스트'),
        ),
        startsAt: DateTime.now().subtract(Duration(hours: 2)),
        endsAt: DateTime.now(),
        current: 1,
        total: 4,
      ),
    ];
  }
}
