import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Swap the implementation later (PBKDF2, Argon2, etc.).
/// Nothing else in the app needs to change.
abstract class PasswordHasher {
  String generateSalt();
  String hash(String password, String salt);

  bool verify(String password, String salt, String expectedHash) {
    final actual = hash(password, salt);
    if (actual.length != expectedHash.length) return false;
    var diff = 0;
    for (var i = 0; i < actual.length; i++) {
      diff |= actual.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
    }
    return diff == 0;
  }
}

class Sha256PasswordHasher extends PasswordHasher {
  @override
  String generateSalt() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return base64Url.encode(bytes);
  }

  @override
  String hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt$password')).toString();
  }
}

final passwordHasherProvider = Provider<PasswordHasher>(
  (ref) => Sha256PasswordHasher(),
);
