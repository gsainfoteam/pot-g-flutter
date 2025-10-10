import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';

part 'pot_accounting_info_model.freezed.dart';
part 'pot_accounting_info_model.g.dart';

@Freezed(toJson: false)
sealed class PotAccountingInfoModel
    with _$PotAccountingInfoModel
    implements PotAccountingInfoEntity {
  const factory PotAccountingInfoModel({
    required bool requested,
    required String? requestingUser,
    required List<String> requestedUsers,
    required int? totalCost,
    required int? costPerUser,
    required String? bankName,
    required String? bankAccount,
  }) = _PotAccountingInfoModel;

  factory PotAccountingInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PotAccountingInfoModelFromJson(json);
}
