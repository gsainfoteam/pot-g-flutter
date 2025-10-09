import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_request_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/archive_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/departure_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_in_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_kick_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_leave_v1_event.dart';

@Injectable(as: PotInfoRepository)
class WebsocketPotInfoRepository implements PotInfoRepository {
  final PotGSocket _socket;
  final ChatPotApi _api;

  WebsocketPotInfoRepository(this._socket, this._api);

  @override
  Stream<PotInfoEntity> getPotInfoStream(PotInfoEntity pot) async* {
    yield await _api.getPotInfo(pot.id);
    yield* _socket
        .createStreamFor<PotEventModel>()
        .where(
          (p) =>
              p is PotEventModel<UserInV1Event> ||
              p is PotEventModel<UserLeaveV1Event> ||
              p is PotEventModel<UserKickV1Event> ||
              p is PotEventModel<DepartureConfirmV1Event> ||
              p is PotEventModel<AccountingRequestV1Event> ||
              p is PotEventModel<AccountingConfirmV1Event> ||
              p is PotEventModel<ArchiveV1Event>,
        )
        .map((e) => e.body)
        .where((e) => e.potPk == pot.id)
        .asyncMap((e) => _api.getPotInfo(pot.id));
  }

  @override
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date) {
    // TODO: implement setDepartureTime
    throw UnimplementedError();
  }
}
