import 'package:dio/dio.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'pot_list_api.g.dart';

@RestApi(baseUrl: '/api/v1/explore/')
abstract class PotListApi {
  factory PotListApi(PotDio dio) = _PotListApi;

  @GET('list')
  Future getList();

  @GET('route')
  Future getRouteList();
}
