import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/user_in_v1_event.dart';

part 'pot_event_model.freezed.dart';
part 'pot_event_model.g.dart';

@Freezed(toJson: false, unionKey: 'event_type')
sealed class PotEventModel with _$PotEventModel {
  factory PotEventModel.chatV1({
    required String potFk,
    required DateTime timestamp,
    required ChatV1Event data,
  }) = _ChatV1;
  factory PotEventModel.userInV1({
    required String potFk,
    required DateTime timestamp,
    required UserInV1Event data,
  }) = _UserInV1;

  factory PotEventModel.fromJson(Map<String, dynamic> json) =>
      _$PotEventModelFromJson(json);
}
