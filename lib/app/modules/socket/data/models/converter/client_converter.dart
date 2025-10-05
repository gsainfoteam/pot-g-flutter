import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/authorization_model.dart';
import 'package:uuid/uuid.dart';

Map<String, dynamic> convertClientMessage<T extends BaseSocketRequestEvent>(
  T request,
  String? requestId,
) {
  final m = BaseSocketRequestModel<T>(
    type: 'unknown',
    requestId: requestId ?? Uuid().v4(),
    body: request,
  );
  final data = switch (request) {
    AuthorizationModel() => m.copyWith(type: 'authorization'),
    _ =>
      throw ArgumentError.value(
        request,
        'request',
        'Unknown request type: ${request.runtimeType}',
      ),
  };
  return data.toJson((json) => json.toJson());
}
