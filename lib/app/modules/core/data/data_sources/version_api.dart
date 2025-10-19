import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/core/data/models/version_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'version_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/version/')
abstract class VersionApi {
  @factoryMethod
  factory VersionApi(PotDio dio) = _VersionApi;

  @GET('')
  Future<VersionResponseModel> getVersion();
}
