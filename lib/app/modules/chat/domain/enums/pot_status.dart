import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PotStatus {
  /// 확정 전
  beforeConfirmed,

  /// 확정
  confirmed,

  /// 정산 전
  waitAccounting,

  /// 정산 완료
  accountingDone,

  /// 해산
  archived,
}
