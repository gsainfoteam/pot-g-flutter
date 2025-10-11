import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/list/data/model/get_pot_list_query_model.dart';
import 'package:pot_g/app/modules/list/data/model/pot_list_model.dart';
import 'package:retrofit/retrofit.dart';

part 'pot_list_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/discovery/')
abstract class PotListApi {
  @factoryMethod
  factory PotListApi(PotDio dio) = _PotListApi;

  @GET('list')
  Future<PotListModel> getList({
    @Queries() required GetPotListQueryModel query,
  });
}
