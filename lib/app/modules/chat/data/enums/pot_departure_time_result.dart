import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.pascal)
enum PotDepartureTimeResult {
  @JsonValue('OK')
  ok,
  notAHost,
  afterDeparture,
  beforeNow,
  potNotExist,
  potAlreadyClosed,
}
