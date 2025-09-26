import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';

part 'bank_model.freezed.dart';
part 'bank_model.g.dart';

@freezed
sealed class BankModel with _$BankModel implements BankEntity {
  const BankModel._();
  const factory BankModel({
    required String id,
    required String bankFullName,
    required String logo,
  }) = _BankModel;

  factory BankModel.fromJson(Map<String, dynamic> json) =>
      _$BankModelFromJson(json);

  @override
  String get name => bankFullName;
  @override
  String get logoUrl => logo;
}
