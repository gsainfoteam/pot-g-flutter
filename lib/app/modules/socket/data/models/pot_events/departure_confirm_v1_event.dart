import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'departure_confirm_v1_event.freezed.dart';
part 'departure_confirm_v1_event.g.dart';

@Freezed(toJson: false)
sealed class DepartureConfirmV1Event
    with _$DepartureConfirmV1Event
    implements PotEvent {
  const factory DepartureConfirmV1Event({
    required String userPk,
    @dateTimeConverter required DateTime departureTime,
  }) = _DepartureConfirmV1Event;

  factory DepartureConfirmV1Event.fromJson(Map<String, dynamic> json) =>
      _$DepartureConfirmV1EventFromJson(json);
}
