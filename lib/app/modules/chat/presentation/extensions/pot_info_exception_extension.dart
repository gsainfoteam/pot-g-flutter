import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/pot_info_exception.dart';
import 'package:pot_g/gen/strings.g.dart';

extension PotInfoExceptionX on PotInfoException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.load_error;
    return switch (this) {
      PotInfoNetworkErrorException() => errors.network_error,
      PotInfoUnknownException() => errors.unknown,
    };
  }
}
