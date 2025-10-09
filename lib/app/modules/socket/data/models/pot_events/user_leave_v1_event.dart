import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'user_leave_v1_event.freezed.dart';
part 'user_leave_v1_event.g.dart';

@Freezed(toJson: false)
sealed class UserLeaveV1Event with _$UserLeaveV1Event implements PotEvent {
  const factory UserLeaveV1Event({required String userPk}) = _UserLeaveV1Event;

  factory UserLeaveV1Event.fromJson(Map<String, dynamic> json) =>
      _$UserLeaveV1EventFromJson(json);
}
