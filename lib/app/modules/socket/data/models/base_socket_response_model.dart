import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_socket_response_model.freezed.dart';
part 'base_socket_response_model.g.dart';

abstract class BaseSocketEventModel {}

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class BaseSocketResponseResultModel<T extends BaseSocketEventModel>
    with _$BaseSocketResponseResultModel<T> {
  const factory BaseSocketResponseResultModel({
    required String responseCode,
    required T? result,
  }) = _BaseSocketResponseResultModel;

  factory BaseSocketResponseResultModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$BaseSocketResponseResultModelFromJson(json, fromJsonT);
}

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class BaseSocketResponseModel<T extends BaseSocketEventModel>
    with _$BaseSocketResponseModel<T> {
  const factory BaseSocketResponseModel({
    required String type,
    required String requestId,
    required BaseSocketResponseResultModel<T> body,
  }) = _BaseSocketResponseModel;

  factory BaseSocketResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$BaseSocketResponseModelFromJson(json, fromJsonT);
}
