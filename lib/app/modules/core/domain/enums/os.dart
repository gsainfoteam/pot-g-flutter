import 'package:json_annotation/json_annotation.dart';

enum OS {
  @JsonValue('AOS')
  android,
  @JsonValue('iOS')
  ios,
}
