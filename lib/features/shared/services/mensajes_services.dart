import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class MensajesServices {
  static Future<List<Map<String, dynamic>>> getMensajes(int chatId) async {
    try {
      String? token = await SessionManager().getAuthToken();
      var user = await SessionManager().getUser();
      Response response = await dio.get(
        '/message/$chatId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(response);
      List<Map<String, dynamic>> mensajes = [];
      if (response.data is List) {
        for (var mensaje in response.data) {
          mensajes.add({
            'id': mensaje['id'],
            'mensaje': mensaje['message'],
            'is_me': mensaje['user_id'] == user['sub'],
            'user_id': mensaje['user_id'],
            'fecha': mensaje['create_date'],
            'estudiante_id':
                mensaje['chat'] != null ? mensaje['chat']['student_id'] : null,
            'reclutador_id': mensaje['chat'] != null
                ? mensaje['chat']['recruiter_id']
                : null,
            'job_id':
                mensaje['chat'] != null ? mensaje['chat']['job_id'] : null,
          });
        }
      }
      return mensajes;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getChats(
      {required String userId, required String type}) async {
    try {
      String? token = await SessionManager().getAuthToken();
      Response response = await dio.get(
        '/chat/$userId?type=$type',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(response);
      List<Map<String, dynamic>> chats = [];
      if (response.data is List) {
        for (var chat in response.data) {
          chats.add({
            'id': chat['id'],
            'student': chat['student'],
            'recruiter': chat['recruiter'],
            'job_id': chat['job_id'],
          });
        }
      }
      return chats;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
