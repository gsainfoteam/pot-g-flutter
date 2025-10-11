import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'create_v1_event.freezed.dart';
part 'create_v1_event.g.dart';

@Freezed(toJson: false)
sealed class CreateV1Event with _$CreateV1Event implements PotEvent {
  const factory CreateV1Event({required String createdBy}) = _CreateV1Event;

  factory CreateV1Event.fromJson(Map<String, dynamic> json) =>
      _$CreateV1EventFromJson(json);
}
