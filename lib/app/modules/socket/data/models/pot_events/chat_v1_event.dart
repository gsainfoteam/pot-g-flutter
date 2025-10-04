import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'chat_v1_event.freezed.dart';
part 'chat_v1_event.g.dart';

@Freezed(toJson: false)
sealed class ChatV1Event with _$ChatV1Event implements PotEvent {
  const factory ChatV1Event({required String from, required String content}) =
      _ChatV1Event;

  factory ChatV1Event.fromJson(Map<String, dynamic> json) =>
      _$ChatV1EventFromJson(json);
}
