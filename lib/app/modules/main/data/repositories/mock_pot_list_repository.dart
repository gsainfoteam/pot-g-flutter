import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/date_time.dart';
import 'package:pot_g/app/modules/main/data/models/pot_model.dart';
import 'package:pot_g/app/modules/main/data/models/route_model.dart';
import 'package:pot_g/app/modules/main/data/models/stop_model.dart';
import 'package:pot_g/app/modules/main/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/main/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/main/domain/repositories/pot_list_repository.dart';

@Injectable(as: PotListRepository)
class MockPotListRepository implements PotListRepository {
  static final _uSquare = StopModel(id: '1', name: '유스퀘어');
  static final _gist = StopModel(id: '2', name: '지스트');
  static final _station = StopModel(id: '3', name: '송정역');

  static final _giToSong = RouteModel(id: '1', from: _gist, to: _uSquare);
  static final _ugi = RouteModel(id: '2', from: _uSquare, to: _gist);
  static final _songToGi = RouteModel(id: '3', from: _station, to: _gist);

  static final _list = [
    PotModel(
      id: '1',
      route: _giToSong,
      startsAt: DateTime.now().copyWith(hour: 13, minute: 10),
      endsAt: DateTime.now().copyWith(hour: 14, minute: 00),
      current: 1,
      total: 4,
    ),
    PotModel(
      id: '2',
      route: _ugi,
      startsAt: DateTime.now()
          .add(Duration(days: 1))
          .copyWith(hour: 8, minute: 0),
      endsAt: DateTime.now()
          .add(Duration(days: 1))
          .copyWith(hour: 11, minute: 0),
      current: 4,
      total: 4,
    ),
    PotModel(
      id: '3',
      route: _ugi,
      startsAt: DateTime.now()
          .add(Duration(days: 1))
          .copyWith(hour: 23, minute: 30),
      endsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 1, minute: 0),
      current: 3,
      total: 4,
    ),
    PotModel(
      id: '4',
      route: _songToGi,
      startsAt: DateTime.now()
          .add(Duration(days: 1))
          .copyWith(hour: 23, minute: 30),
      endsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 1, minute: 10),
      current: 3,
      total: 4,
    ),
    PotModel(
      id: '5',
      route: _songToGi,
      startsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 18, minute: 0),
      endsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 20, minute: 0),
      current: 4,
      total: 4,
    ),
    PotModel(
      id: '6',
      route: _ugi,
      startsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 19, minute: 0),
      endsAt: DateTime.now()
          .add(Duration(days: 2))
          .copyWith(hour: 20, minute: 0),
      current: 4,
      total: 4,
    ),
    PotModel(
      id: '7',
      route: _songToGi,
      startsAt: DateTime.now()
          .add(Duration(days: 3))
          .copyWith(hour: 18, minute: 0),
      endsAt: DateTime.now()
          .add(Duration(days: 3))
          .copyWith(hour: 20, minute: 0),
      current: 3,
      total: 4,
    ),
  ];

  @override
  Future<List<PotEntity>> getPotList({
    DateTime? date,
    RouteEntity? route,
  }) async {
    if (date == null) {
      return _list;
    }
    return _list
        .where(
          (pot) => pot.startsAt.isSameDay(date) || pot.endsAt.isSameDay(date),
        )
        .toList();
  }
}
