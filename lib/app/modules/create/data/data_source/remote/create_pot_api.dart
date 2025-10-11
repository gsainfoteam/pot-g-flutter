import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/create/data/model/create_pot_model.dart';
import 'package:pot_g/app/modules/create/data/model/create_pot_result_model.dart';
import 'package:retrofit/retrofit.dart';

part 'create_pot_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/pot/')
abstract class CreatePotApi {
  @factoryMethod
  factory CreatePotApi(PotDio dio) = _CreatePotApi;

  @POST('create')
  Future<CreatePotResultModel> createPot(@Body() CreatePotModel body);
}
