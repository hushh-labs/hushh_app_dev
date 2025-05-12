import 'dart:convert';

import 'package:crypto/crypto.dart';

class Encryption {
  static String encrypt(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    var encryptedString = digest.toString();
    return encryptedString;
  }
}
