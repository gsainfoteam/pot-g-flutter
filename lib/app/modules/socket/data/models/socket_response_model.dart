import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/request_authorization_event_model.dart';

part 'socket_response_model.freezed.dart';
part 'socket_response_model.g.dart';

@Freezed(toJson: false, unionKey: 'type')
sealed class SocketResponseModel with _$SocketResponseModel {
  factory SocketResponseModel.requestAuthorization(
    String requestId,
    RequestAuthorizationEventModel body,
  ) = _RequestAuthorization;
  factory SocketResponseModel.potEventReceive(
    String requestId,
    PotEventModel body,
  ) = _PotEvent;

  factory SocketResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SocketResponseModelFromJson(json);
}
