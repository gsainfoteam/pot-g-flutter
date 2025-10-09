import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'popo_chat_v1_event.freezed.dart';
part 'popo_chat_v1_event.g.dart';

@Freezed(toJson: false)
sealed class PopoChatV1Event with _$PopoChatV1Event implements PotEvent {
  const factory PopoChatV1Event({
    required PopoChatType popoChatType,
    required String content,
    required List<PopoActionButtonType> actionBtns,
  }) = _PopoChatV1Event;

  factory PopoChatV1Event.fromJson(Map<String, dynamic> json) =>
      _$PopoChatV1EventFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.kebab)
enum PopoChatType {
  popoDepartureConfirmRequestV1,
  popoDepartureConfirmedV1,
  popoReminderTaxiCallV1,
  popoAccountingReminderV1,
  popoAccountingRequestV1,
}

@JsonEnum(fieldRename: FieldRename.kebab)
enum PopoActionButtonType {
  departureConfirmBtn,
  taxiCallBtn,
  accountingRequestBtn,
  accountingInfoCheckBtn,
  accountingProcessBtn,
}
