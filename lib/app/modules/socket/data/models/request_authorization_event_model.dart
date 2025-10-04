import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_authorization_event_model.freezed.dart';
part 'request_authorization_event_model.g.dart';

@freezed
sealed class RequestAuthorizationEventModel
    with _$RequestAuthorizationEventModel {
  const factory RequestAuthorizationEventModel({
    required final DateTime authorizationUntil,
  }) = _RequestAuthorizationEventModel;

  factory RequestAuthorizationEventModel.fromJson(Map<String, dynamic> json) =>
      _$RequestAuthorizationEventModelFromJson(json);
}
