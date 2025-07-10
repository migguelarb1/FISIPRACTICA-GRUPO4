import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:logger/logger.dart';

final SessionManager _sessionManager = SessionManager();
final Logger logger = Logger();

class ChatServices {
  Future<Map<String, dynamic>> createChat(
      int studentId, int jobId, int? recruiterId) async {
    try {
      final token = await _sessionManager.getAuthToken();
      final response = await dio.post(
        '/chat',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'student_id': studentId,
          'job_id': jobId,
          if (recruiterId != null) 'recruiter_id': recruiterId,
        },
      );
      return response.data;
    } catch (e) {
      logger.e('Error al crear el chat: $e');
      return {};
    }
  }
}
