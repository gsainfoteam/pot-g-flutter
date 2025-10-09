import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'archive_v1_event.freezed.dart';
part 'archive_v1_event.g.dart';

@Freezed(toJson: false)
sealed class ArchiveV1Event with _$ArchiveV1Event implements PotEvent {
  const factory ArchiveV1Event() = _ArchiveV1Event;

  factory ArchiveV1Event.fromJson(Map<String, dynamic> json) =>
      _$ArchiveV1EventFromJson(json);
}
