import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_server_message_model.freezed.dart';
part 'base_server_message_model.g.dart';

abstract class BaseServerMessageEvent {}

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class BaseServerMessageModel<T extends BaseServerMessageEvent>
    with _$BaseServerMessageModel<T> {
  const factory BaseServerMessageModel({
    required String type,
    required String requestId,
    required T body,
  }) = _BaseServerMessageModel<T>;

  factory BaseServerMessageModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$BaseServerMessageModelFromJson(json, fromJsonT);
}
