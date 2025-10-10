import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';

part 'chat_model.freezed.dart';

@freezed
sealed class ChatModel with _$ChatModel implements ChatEntity {
  const factory ChatModel({
    required String message,
    required PotUserEntity user,
    @dateTimeConverter required DateTime createdAt,
  }) = _ChatModel;
}
