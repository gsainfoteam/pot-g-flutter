import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base_socket_response_model.dart';

part 'request_authorization_event_model.freezed.dart';
part 'request_authorization_event_model.g.dart';

@freezed
sealed class RequestAuthorizationEventModel
    with _$RequestAuthorizationEventModel
    implements BaseSocketEventModel {
  const RequestAuthorizationEventModel._();
  const factory RequestAuthorizationEventModel({
    required final DateTime authorizationUntil,
  }) = _RequestAuthorizationEventModel;

  factory RequestAuthorizationEventModel.fromJson(Map<String, dynamic> json) =>
      _$RequestAuthorizationEventModelFromJson(json);

  @override
  String get type => 'request_authorization';
}
