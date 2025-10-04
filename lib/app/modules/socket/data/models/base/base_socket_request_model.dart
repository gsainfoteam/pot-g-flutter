import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_socket_request_model.freezed.dart';
part 'base_socket_request_model.g.dart';

abstract class BaseSocketRequestEvent {
  Map<String, dynamic> toJson();
}

@Freezed(fromJson: false, toJson: true, genericArgumentFactories: true)
sealed class BaseSocketRequestModel<T extends BaseSocketRequestEvent>
    with _$BaseSocketRequestModel<T> {
  const factory BaseSocketRequestModel({
    required String type,
    required String requestId,
    required T body,
  }) = _BaseSocketRequestModel;
}
