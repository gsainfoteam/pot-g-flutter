import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'user_kick_v1_event.freezed.dart';
part 'user_kick_v1_event.g.dart';

@Freezed(toJson: false)
sealed class UserKickV1Event with _$UserKickV1Event implements PotEvent {
  const factory UserKickV1Event({
    required String hostUserPk,
    required String kickedUserPk,
  }) = _UserKickV1Event;

  factory UserKickV1Event.fromJson(Map<String, dynamic> json) =>
      _$UserKickV1EventFromJson(json);
}
