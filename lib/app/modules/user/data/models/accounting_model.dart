import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/user/domain/entities/accounting_entity.dart';

part 'accounting_model.freezed.dart';
part 'accounting_model.g.dart';

@freezed
sealed class AccountingModel
    with _$AccountingModel
    implements AccountingEntity {
  const factory AccountingModel({
    required bool isSet,
    String? bankShortName,
    String? account,
  }) = _AccountingModel;

  factory AccountingModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingModelFromJson(json);
}
