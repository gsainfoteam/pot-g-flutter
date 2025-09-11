import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/models/login_request_model.dart';
import 'package:pot_g/app/modules/auth/data/models/login_response_model.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_request_model.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_auth_api.g.dart';

@RestApi(baseUrl: 'v1/user')
abstract class UserAuthApi {
  @factoryMethod
  factory UserAuthApi(Dio dio) = _UserAuthApi;

  @POST('login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @POST('refresh')
  Future<RefreshResponseModel> refresh(@Body() RefreshRequestModel request);
}
