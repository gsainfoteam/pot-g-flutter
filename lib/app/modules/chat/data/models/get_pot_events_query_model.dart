import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';

part 'get_pot_events_query_model.freezed.dart';
part 'get_pot_events_query_model.g.dart';

@Freezed(toJson: true)
sealed class GetPotEventsQueryModel with _$GetPotEventsQueryModel {
  const factory GetPotEventsQueryModel({
    @Default(20) int? limit,
    @EpochDateTimeConverter() required DateTime startsFrom,
  }) = _GetPotEventsQueryModel;
}
