import 'package:freezed_annotation/freezed_annotation.dart';

part 'pot_user_model.freezed.dart';
part 'pot_user_model.g.dart';

@Freezed(toJson: false)
sealed class PotUserModel with _$PotUserModel {
  const factory PotUserModel({
    required String id,
    required String name,
    required bool isHost,
    required bool isInPot,
  }) = _PotUserModel;

  factory PotUserModel.fromJson(Map<String, dynamic> json) =>
      _$PotUserModelFromJson(json);
}
