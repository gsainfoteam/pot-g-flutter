import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';

part 'authorization_model.freezed.dart';
part 'authorization_model.g.dart';

@Freezed(toJson: true)
sealed class AuthorizationModel
    with _$AuthorizationModel
    implements BaseSocketRequestEvent {
  const factory AuthorizationModel({required String authorization}) =
      _AuthorizationModel;
}
