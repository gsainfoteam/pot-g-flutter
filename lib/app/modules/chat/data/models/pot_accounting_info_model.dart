import 'package:freezed_annotation/freezed_annotation.dart';

part 'pot_accounting_info_model.freezed.dart';
part 'pot_accounting_info_model.g.dart';

@Freezed(toJson: false)
sealed class PotAccountingInfoModel with _$PotAccountingInfoModel {
  const factory PotAccountingInfoModel({
    required bool requested,
    required String? requestingUser,
    required List<String> requestedUsers,
  }) = _PotAccountingInfoModel;

  factory PotAccountingInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PotAccountingInfoModelFromJson(json);
}
