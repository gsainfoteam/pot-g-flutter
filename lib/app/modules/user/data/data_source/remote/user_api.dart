import 'package:pot_g/app/modules/user/data/models/self_user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: 'v1/user')
abstract class UserApi {
  @GET('info')
  Future<SelfUserModel> getUser();
}
