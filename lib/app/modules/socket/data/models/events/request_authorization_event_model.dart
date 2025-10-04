import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';

part 'request_authorization_event_model.freezed.dart';
part 'request_authorization_event_model.g.dart';

@Freezed(toJson: false)
sealed class RequestAuthorizationEventModel
    with _$RequestAuthorizationEventModel
    implements BaseServerMessageEvent {
  const factory RequestAuthorizationEventModel({
    required DateTime authorizationUntil,
  }) = _RequestAuthorizationEventModel;

  factory RequestAuthorizationEventModel.fromJson(Map<String, dynamic> json) =>
      _$RequestAuthorizationEventModelFromJson(json);
}
