import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';

part 'pot_event_model.freezed.dart';
part 'pot_event_model.g.dart';

abstract class PotEvent {}

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class PotEventModel<T extends PotEvent>
    with _$PotEventModel<T>
    implements BaseServerMessageEvent {
  const factory PotEventModel({
    required String potPk,
    @EpochDateTimeConverter() required DateTime timestamp,
    required String eventType,
    required T data,
  }) = _PotEventModel;

  factory PotEventModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PotEventModelFromJson(json, fromJsonT);
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) =>
      DateTime.fromMillisecondsSinceEpoch(json * 1000);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch ~/ 1000;
}
