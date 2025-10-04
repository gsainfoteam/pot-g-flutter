import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_v1_event.freezed.dart';
part 'chat_v1_event.g.dart';

@Freezed(toJson: false)
sealed class ChatV1Event with _$ChatV1Event {
  const factory ChatV1Event({required String from, required String content}) =
      _ChatV1Event;

  factory ChatV1Event.fromJson(Map<String, dynamic> json) =>
      _$ChatV1EventFromJson(json);
}
