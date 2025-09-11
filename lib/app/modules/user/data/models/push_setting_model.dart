import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_setting_model.freezed.dart';
part 'push_setting_model.g.dart';

@freezed
sealed class PushSettingModel with _$PushSettingModel {
  const factory PushSettingModel({
    required bool anyPush,
    required bool chatPush,
    required bool potInOutPush,
    required bool marketingPush,
  }) = _PushSettingModel;

  factory PushSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PushSettingModelFromJson(json);
}
