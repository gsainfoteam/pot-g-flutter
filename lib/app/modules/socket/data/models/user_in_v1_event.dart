import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_in_v1_event.freezed.dart';
part 'user_in_v1_event.g.dart';

@Freezed(toJson: false)
sealed class UserInV1Event with _$UserInV1Event {
  const factory UserInV1Event({required String userPk}) = _UserInV1Event;

  factory UserInV1Event.fromJson(Map<String, dynamic> json) =>
      _$UserInV1EventFromJson(json);
}
