import 'package:pot_g/app/modules/chat/data/models/my_pots_model.dart';

abstract interface class PotDetailRepository {
  Stream<MyPotsModel> getMyPotList();
}
