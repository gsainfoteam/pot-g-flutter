import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/models/token_model.dart';
import 'package:pot_g/app/modules/auth/data/models/token_request_with_code_model.dart';
import 'package:pot_g/app/modules/auth/data/models/token_request_with_refresh_model.dart';
import 'package:retrofit/retrofit.dart';

part 'oauth_api.g.dart';

@injectable
@RestApi(baseUrl: 'https://api.idp.gistory.me/oauth/')
abstract class OAuthApi {
  @factoryMethod
  factory OAuthApi(Dio dio) = _OAuthApi;

  @POST('token')
  Future<TokenModel> getTokenFromCode(
    @Body() TokenRequestWithCodeModel request,
  );

  @POST('token')
  Future<TokenModel> getTokenFromRefresh(
    @Body() TokenRequestWithRefreshModel request,
  );
}
