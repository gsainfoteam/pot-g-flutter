import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';

part 'send_chat_model.freezed.dart';
part 'send_chat_model.g.dart';

@Freezed(fromJson: false, toJson: true)
sealed class SendChatModel
    with _$SendChatModel
    implements BaseSocketRequestEvent {
  const factory SendChatModel({
    required String message,
    required String potPk,
  }) = _SendChatModel;
}
