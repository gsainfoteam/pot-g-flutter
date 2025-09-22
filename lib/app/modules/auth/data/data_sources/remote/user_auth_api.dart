import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:pot_g/app/modules/auth/data/models/login_request_model.dart';
import 'package:pot_g/app/modules/auth/data/models/login_response_model.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_request_model.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_response_model.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/user/data/models/self_user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_auth_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/user/')
abstract class UserAuthApi {
  @factoryMethod
  factory UserAuthApi(PotDio dio) = _UserAuthApi;

  @POST('login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @POST('refresh')
  @PreventRetry()
  Future<RefreshResponseModel> refresh(@Body() RefreshRequestModel request);

  @GET('info')
  Future<SelfUserModel> getUser();
}
