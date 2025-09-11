import 'package:pot_g/app/modules/user/data/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

@RestApi(baseUrl: 'v1/user')
abstract class UserApi {
  @GET('info')
  Future<UserModel> getUser();
}
