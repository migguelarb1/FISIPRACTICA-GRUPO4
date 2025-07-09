import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final _secureStorage = const FlutterSecureStorage();
  final Future<SharedPreferencesWithCache> _prefsWithCache =
      SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      // When an allowlist is included, any keys that aren't included cannot be used.
      allowList: <String>{'is_logged_in', 'user'},
    ),
  );

  // Claves para el almacenamiento
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUser = 'user';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // --- Métodos de Sesión ---

  // Guarda la sesión del usuario al hacer login
  Future<void> createSession(String token, Object user) async {
    // Guarda el token de forma segura
    await _secureStorage.write(key: _keyAuthToken, value: token);

    // Guarda otros datos no sensibles
    final prefs = await _prefsWithCache;
    await prefs.setString(_keyUser, jsonEncode(user));
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Cierra la sesión del usuario
  Future<void> destroySession() async {
    // Borra el token seguro
    await _secureStorage.delete(key: _keyAuthToken);

    // Borra los datos no sensibles
    final prefs = await _prefsWithCache;
    await prefs.remove(_keyUser);
    await prefs.remove(_keyIsLoggedIn);
  }

  // --- Métodos para obtener datos ---

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _keyAuthToken);
  }

  Future<Map<String, dynamic>> getUser() async {
    final prefs = await _prefsWithCache;
    return jsonDecode(prefs.getString(_keyUser) ?? '{}')
        as Map<String, dynamic>;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await _prefsWithCache;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
