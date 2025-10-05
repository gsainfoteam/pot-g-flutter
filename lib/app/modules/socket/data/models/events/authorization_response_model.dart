import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';

part 'authorization_response_model.freezed.dart';
part 'authorization_response_model.g.dart';

@Freezed(toJson: false)
sealed class AuthorizationResponseModel
    with _$AuthorizationResponseModel
    implements BaseServerMessageEvent {
  const factory AuthorizationResponseModel({
    required int responseCode,
    required String result,
  }) = _AuthorizationResponseModel;

  factory AuthorizationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationResponseModelFromJson(json);
}
