import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_socket_request_model.freezed.dart';
part 'base_socket_request_model.g.dart';

@freezed
sealed class BaseSocketRequestModel with _$BaseSocketRequestModel {
  const factory BaseSocketRequestModel({
    required String type,
    required String requestId,
    required String body,
  }) = _BaseSocketRequestModel;

  factory BaseSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BaseSocketRequestModelFromJson(json);
}
