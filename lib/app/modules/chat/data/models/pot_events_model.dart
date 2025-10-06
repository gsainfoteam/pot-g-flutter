import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/server_converter.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'pot_events_model.freezed.dart';
part 'pot_events_model.g.dart';

@Freezed(toJson: false)
sealed class PotEventsModel with _$PotEventsModel {
  const factory PotEventsModel({
    @_Converter() required List<PotEventModel> events,
  }) = _PotEventsModel;

  factory PotEventsModel.fromJson(Map<String, dynamic> json) =>
      _$PotEventsModelFromJson(json);
}

class _Converter implements JsonConverter<PotEventModel, Map<String, dynamic>> {
  const _Converter();

  @override
  PotEventModel fromJson(Map<String, dynamic> json) {
    return convertPotEvent(json);
  }

  @override
  Map<String, dynamic> toJson(PotEventModel<PotEvent> object) {
    throw UnimplementedError();
  }
}
