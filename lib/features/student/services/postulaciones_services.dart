import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final SessionManager _sessionManager = SessionManager();

class PostulacionesServices {
  static Future<bool> postularse(int ofertaId) async {
    try {
      String? token = await _sessionManager.getAuthToken();
      Map<String, dynamic> user = await _sessionManager.getUser();
      await dio.post(
        '/application',
        data: {
          'job_id': ofertaId,
          'student_id': user['student_id'],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return true;
    } catch (e) {
      logger.e("Error al postularse: $e");
      return false;
    }
  }
}
