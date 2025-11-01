import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/my_pots_model.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_detail_repository.dart';

@Injectable(as: PotDetailRepository)
class RestPotDetailRepository implements PotDetailRepository {
  final ChatPotApi _api;

  RestPotDetailRepository(this._api);

  @override
  Stream<MyPotsModel> getMyPotList() async* {
    final MyPotsModel pots = await _api.getMyPots();
    yield pots;
  }
}
