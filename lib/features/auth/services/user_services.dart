import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class UserServices {
  static Future<Map<String, String>> login(
      String email, String password, String role) async {
    try {
      Response response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
      );
      await SessionManager().set('token', response.data['access_token']);
      return {
        'token': response.data['access_token'],
      };
    } catch (e) {
      logger.e(e);
      return {};
    }
  }

  static Future<void> logout() async {
    try {
      String email = (await getUser())['email'];
      String? token = await getToken();
      await SessionManager().destroy();
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
      await SessionManager().destroy();
    }
  }

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Future<String?> getToken() async {
    return await SessionManager().get('token');
  }

  static void setUser() async {
    try {
      final user = JwtDecoder.decode(_token!);
      await SessionManager().set('user', user);
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await SessionManager().get('token');
      if (token == null) {
        return {};
      }
      final user = JwtDecoder.decode(token);
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
  }
}
