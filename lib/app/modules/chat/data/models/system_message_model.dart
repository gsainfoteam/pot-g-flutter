import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';

part 'system_message_model.freezed.dart';

@freezed
sealed class SystemMessageModel
    with _$SystemMessageModel
    implements SystemMessageEntity {
  const factory SystemMessageModel({
    required SystemMessageType type,
    required PotUserEntity relatedUser,
    @dateTimeConverter required DateTime createdAt,
  }) = _SystemMessageModel;
}
