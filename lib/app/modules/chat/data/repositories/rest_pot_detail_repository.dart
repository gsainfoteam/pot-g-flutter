import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/my_pots_model.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_detail_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_request_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/archive_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/create_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/departure_confirm_v1_event.dart';

bool _isPotStatusChangeEvent(PotEventModel e) {
  return e is PotEventModel<CreateV1Event> ||
      e is PotEventModel<ArchiveV1Event> ||
      e is PotEventModel<DepartureConfirmV1Event> ||
      e is PotEventModel<AccountingRequestV1Event> ||
      e is PotEventModel<AccountingConfirmV1Event>;
}

@Injectable(as: PotDetailRepository)
class RestPotDetailRepository implements PotDetailRepository {
  final ChatPotApi _api;
  final PotGSocket _socket;

  RestPotDetailRepository(this._api, this._socket);

  @override
  Stream<MyPotsModel> getMyPotList() async* {
    final MyPotsModel pots = await _api.getMyPots();
    yield pots;
    yield* _socket
        .createStreamFor<PotEventModel>()
        .map((e) => e.body)
        .where(_isPotStatusChangeEvent)
        .asyncMap((_) => _api.getMyPots());
  }
}
