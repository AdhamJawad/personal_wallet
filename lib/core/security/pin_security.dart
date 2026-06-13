import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

sealed class PinSecurity {
  static String generateSalt() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(
      24,
      (_) => random.nextInt(256),
      growable: false,
    );
    return base64UrlEncode(bytes);
  }

  static String hashPin({required String pin, required String salt}) {
    return sha256.convert(utf8.encode('$salt::$pin')).toString();
  }
}
