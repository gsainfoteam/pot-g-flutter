import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/list/data/models/join_pot_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'join_pot_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/pot/')
abstract class JoinPotApi {
  @factoryMethod
  factory JoinPotApi(PotDio dio) = _JoinPotApi;

  @POST('{id}/in')
  Future<JoinPotResponseModel> joinPot(@Path('id') String id);
}
