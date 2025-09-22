import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/user/data/models/self_user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/user/')
abstract class UserApi {
  @factoryMethod
  factory UserApi(PotDio dio) = _UserApi;

  @GET('info')
  Future<SelfUserModel> getUser();
}
