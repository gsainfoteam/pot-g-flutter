import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_request_request_model.freezed.dart';
part 'accounting_request_request_model.g.dart';

@Freezed(toJson: true)
sealed class AccountingRequestRequestModel
    with _$AccountingRequestRequestModel {
  const factory AccountingRequestRequestModel({
    required int totalCost,
    required int costPerUser,
    required AccountInfo accountInfo,
    required List<String> requestedUser,
  }) = _AccountingRequestRequestModel;
}

@Freezed(toJson: true)
sealed class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required bool useExistInfo,
    String? bankPk,
    String? account,
    bool? needSet,
  }) = _AccountInfo;
}
