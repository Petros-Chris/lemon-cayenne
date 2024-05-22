import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt() {
  final random = Random.secure();
  final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64Url.encode(saltBytes);
}

String hashPassword(String password, String salt) {
  const codec = Utf8Codec();
  final key = codec.encode(password);
  final hmac = Hmac(sha256, codec.encode(salt));
  final digest = hmac.convert(key);
  return base64Url.encode(digest.bytes);
}
