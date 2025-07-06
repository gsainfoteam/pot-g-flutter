import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/domain/repositories/route_list_repository.dart';

@LazySingleton(as: RouteListRepository)
class MockRouteListRepository extends RouteListRepository {
  static final _uSquare = StopModel(id: '1', name: '유스퀘어');
  static final _gist = StopModel(id: '2', name: '지스트');
  static final _station = StopModel(id: '3', name: '송정역');

  @override
  Future<List<RouteEntity>> getRouteList() async {
    return [
      RouteModel(id: '1', from: _gist, to: _station),
      RouteModel(id: '2', from: _gist, to: _uSquare),
      RouteModel(id: '3', from: _station, to: _gist),
      RouteModel(id: '4', from: _uSquare, to: _gist),
    ];
  }
}
