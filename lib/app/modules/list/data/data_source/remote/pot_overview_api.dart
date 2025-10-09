import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/list/data/models/pot_overview_model.dart';
import 'package:retrofit/retrofit.dart';

part 'pot_overview_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/pot/')
abstract class PotOverviewApi {
  @factoryMethod
  factory PotOverviewApi(PotDio dio) = _PotOverviewApi;

  @GET('{id}/overview')
  Future<PotOverviewModel> getPotOverview(@Path('id') String id);
}
