import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'accounting_request_v1_event.freezed.dart';
part 'accounting_request_v1_event.g.dart';

@Freezed(toJson: false)
sealed class AccountingRequestV1Event
    with _$AccountingRequestV1Event
    implements PotEvent {
  const factory AccountingRequestV1Event({
    required String requestUserPk,
    required List<String> requestedUsersPk,
    required int totalCost,
    required int costPerUser,
    required String bankPk,
    required String bankName,
    required String bankAccount,
  }) = _AccountingRequestV1Event;

  factory AccountingRequestV1Event.fromJson(Map<String, dynamic> json) =>
      _$AccountingRequestV1EventFromJson(json);
}
