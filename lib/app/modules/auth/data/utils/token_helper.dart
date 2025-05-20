import 'dart:convert';

abstract class TokenHelper {
  TokenHelper._();

  static Map<String, dynamic> getPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid JWT structure');
    }
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload;
    } catch (e) {
      throw FormatException('Invalid JWT payload: $e');
    }
  }
}
