import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_socket_response_model.freezed.dart';
part 'base_socket_response_model.g.dart';

@freezed
sealed class BaseSocketResponseResultModel
    with _$BaseSocketResponseResultModel {
  const factory BaseSocketResponseResultModel({
    required String responseCode,
    required String? result,
  }) = _BaseSocketResponseResultModel;

  factory BaseSocketResponseResultModel.fromJson(Map<String, dynamic> json) =>
      _$BaseSocketResponseResultModelFromJson(json);
}

@freezed
sealed class BaseSocketResponseModel with _$BaseSocketResponseModel {
  const factory BaseSocketResponseModel({
    required String type,
    required String requestId,
    required BaseSocketResponseResultModel body,
  }) = _BaseSocketResponseModel;

  factory BaseSocketResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseSocketResponseModelFromJson(json);
}
