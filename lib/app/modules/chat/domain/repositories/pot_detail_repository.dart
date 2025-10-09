import 'package:pot_g/app/modules/chat/data/models/my_pots_model.dart';

abstract class PotDetailRepository {
  Future<MyPotsModel> getMyPotList();
}
