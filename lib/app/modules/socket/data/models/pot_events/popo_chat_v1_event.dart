import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_action_button_type.dart';
import 'package:pot_g/app/modules/chat/domain/enums/fofo_chat_type.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'popo_chat_v1_event.freezed.dart';
part 'popo_chat_v1_event.g.dart';

@Freezed(toJson: false)
sealed class PopoChatV1Event with _$PopoChatV1Event implements PotEvent {
  const PopoChatV1Event._();
  const factory PopoChatV1Event({
    @JsonKey(unknownEnumValue: PopoChatType.unknown)
    required PopoChatType popoChatType,
    required String content,
    @JsonKey(unknownEnumValue: PopoActionButtonType.unknown)
    required List<PopoActionButtonType> actionBtns,
  }) = _PopoChatV1Event;

  factory PopoChatV1Event.fromJson(Map<String, dynamic> json) =>
      _$PopoChatV1EventFromJson(json);

  FofoChat toEntity(DateTime timestamp) => FofoChat(
    type: popoChatType.fofoChatType,
    content: content,
    actionButtons: actionBtns.map((e) => e.fofoActionButtonType).toList(),
    createdAt: timestamp,
  );
}

@freezed
sealed class FofoChat with _$FofoChat implements FofoChatEntity {
  const factory FofoChat({
    required FofoChatType? type,
    required String content,
    required List<FofoActionButtonType?> actionButtons,
    required DateTime createdAt,
  }) = _FofoChat;
}

@JsonEnum(fieldRename: FieldRename.kebab)
enum PopoChatType {
  popoDepartureConfirmRequestV1,
  popoDepartureConfirmedV1,
  popoReminderTaxiCallV1,
  popoAccountingReminderV1,
  popoAccountingRequestV1,
  popoAutoArchiveNoDepartureConfirmV1,
  popoAutoArchiveAccountingFinV1,
  popoAutoArchiveV1,
  unknown;

  FofoChatType? get fofoChatType => switch (this) {
    popoDepartureConfirmRequestV1 => FofoChatType.departureConfirmRequest,
    popoDepartureConfirmedV1 => FofoChatType.departureConfirmed,
    popoReminderTaxiCallV1 => FofoChatType.reminderTaxiCall,
    popoAccountingReminderV1 => FofoChatType.accountingReminder,
    popoAccountingRequestV1 => FofoChatType.accountingRequest,
    popoAutoArchiveNoDepartureConfirmV1 =>
      FofoChatType.autoArchiveNoDepartureConfirm,
    popoAutoArchiveAccountingFinV1 =>
      FofoChatType.autoArchiveAccountingFinished,
    popoAutoArchiveV1 => FofoChatType.autoArchive,
    unknown => null,
  };
}

@JsonEnum(fieldRename: FieldRename.kebab)
enum PopoActionButtonType {
  departureConfirmBtn,
  taxiCallBtn,
  accountingRequestBtn,
  accountingInfoCheckBtn,
  accountingProcessBtn,
  unknown;

  FofoActionButtonType? get fofoActionButtonType => switch (this) {
    departureConfirmBtn => FofoActionButtonType.departureConfirm,
    taxiCallBtn => FofoActionButtonType.taxiCall,
    accountingRequestBtn => FofoActionButtonType.accountingRequest,
    accountingInfoCheckBtn => FofoActionButtonType.accountingInfoCheck,
    accountingProcessBtn => FofoActionButtonType.accountingProcess,
    unknown => null,
  };
}
