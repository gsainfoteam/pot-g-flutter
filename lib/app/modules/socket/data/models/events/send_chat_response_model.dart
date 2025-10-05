import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';

part 'send_chat_response_model.freezed.dart';
part 'send_chat_response_model.g.dart';

@Freezed(toJson: false)
sealed class SendChatResponseModel
    with _$SendChatResponseModel
    implements BaseServerMessageEvent {
  const factory SendChatResponseModel({
    required int responseCode,
    required String result,
  }) = _SendChatResponseModel;

  factory SendChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendChatResponseModelFromJson(json);
}
