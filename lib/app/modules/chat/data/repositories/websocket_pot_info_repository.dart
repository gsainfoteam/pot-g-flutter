import 'package:dio/dio.dart' show DioException;
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/pot_info_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';
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
  Stream<PotInfoEntity> getPotInfoStream(PotIdEntity pot) async* {
    try {
      yield await _api.getPotInfo(pot.id);
    } on DioException catch (e) {
      throw PotInfoException.networkError(e.message ?? e.error.toString());
    } catch (e) {
      throw PotInfoException.unknown(e);
    }

    yield* _socket
        .createStreamFor<PotEventModel>()
        .map((e) => e.body)
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
        .where((e) => e.potPk == pot.id)
        .asyncMap((e) async {
          try {
            return await _api.getPotInfo(pot.id);
          } on DioException catch (e) {
            throw PotInfoException.networkError(
              e.message ?? e.error.toString(),
            );
          } catch (e) {
            throw PotInfoException.unknown(e);
          }
        });
  }
}
