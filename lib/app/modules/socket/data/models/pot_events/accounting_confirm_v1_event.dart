import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'accounting_confirm_v1_event.freezed.dart';
part 'accounting_confirm_v1_event.g.dart';

@Freezed(toJson: false)
sealed class AccountingConfirmV1Event
    with _$AccountingConfirmV1Event
    implements PotEvent {
  const factory AccountingConfirmV1Event() = _AccountingConfirmV1Event;

  factory AccountingConfirmV1Event.fromJson(Map<String, dynamic> json) =>
      _$AccountingConfirmV1EventFromJson(json);
}
