import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final SessionManager _sessionManager = SessionManager();

class UserServices {
  static Future<bool> login(String email, String password, String role) async {
    try {
      Response response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      final user = JwtDecoder.decode(response.data['access_token']);
      await _sessionManager.createSession(response.data['access_token'], user);

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      String email = (await _sessionManager.getUser())['email'];
      String? token = await _sessionManager.getAuthToken();
      // await SessionManager().destroy();
      /* Response response =  */ await dio.post(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {'email': email},
      );
    } catch (e) {
      logger.e(e);
      rethrow;
    } finally {
      // await SessionManager().destroy();
      await _sessionManager.destroySession();
    }
  }
/* 
  static Future<bool> isLoggedIn() async {
    final prefs = await _prefsWithCache;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Future<String?> getToken() async {
    final prefs = await _prefsWithCache;
    // return await SessionManager().get('token');
    return prefs.getString(_tokenKey);
  }

  static void setUser() async {
    try {
      final prefs = await _prefsWithCache;
      final user = JwtDecoder.decode(_token!);
      // await SessionManager().set('user', user);
      await prefs.setString('user', jsonEncode(user));
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await getToken();
      logger.d(token);
      if (token == null) {
        return {};
      }
      final user = JwtDecoder.decode(token);
      logger.d(user);
      return user;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<String?> getUserId() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken["sub"]
          .toString(); // Asegúrate de que la clave sea 'id'
    } catch (e) {
      logger.e("Error obteniendo el ID del usuario: $e");
      return null;
    }
  } */
}
