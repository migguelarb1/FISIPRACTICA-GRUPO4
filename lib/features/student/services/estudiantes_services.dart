import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_app/features/auth/services/user_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final dio = Dio();

class EstudiantesServices {
  static Future<Map<String, dynamic>> registerEstudiante(body) async {
    try {
      final email = body['email'];
      final password = body['password'];
      final firstName = body['apellidos'];
      final lastName = body['nombres'];
      String? token = await UserServices.getToken();
      Response response = await dio.post(
        '${dotenv.env['API_DOMAIN']}/student',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data'
          },
        ),
        data: FormData.fromMap({
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          // Add other fields as required
        }),
      );
      return response.data;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  // static Future<Map<String, dynamic>> updateEstudiante(body) async {
  //   try{
  //     final nombre = body['nombre'];
  //     final apellido = body['apellido'];
  //     final email = body['email'];
  //     final password = body['password'];
  //     final institution = body['institution'];
  //     final fecha_inicio = body['fecha_inicio'];
  //     final fecha_fin = body['fecha_fin'];
  //     final estudiando = body['estudiando'];
  //     final descripcion = body['descripcion'];
  //     final
  //   }
  //   catch(e){
  //     logger.e(e);
  //     rethrow;
  //   }
  // }

  static Future<List<Map<String, dynamic>>> getEstudiantes() async {
    try {
      String? token = await UserServices.getToken();
      Response response = await dio.get(
        '${dotenv.env['API_DOMAIN']}/student',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(response);
      List<Map<String, dynamic>> estudiantes = [];
      for (var estudiante in response.data) {
        Uint8List? foto;
        if (estudiante['userProfile'] != null &&
            estudiante['userProfile']['photo'] != null) {
          foto = Uint8List.fromList(
              (estudiante['userProfile']['photo']['data'] as List<dynamic>)
                  .cast<int>());
        }
        estudiantes.add({
          'nombre': estudiante['userProfile'] != null
              ? "${estudiante['userProfile']['first_name']} ${estudiante['userProfile']['last_name']}"
              : "No disponible",
          'foto': foto ?? 'assets/profile_picture.jpg',
          'descripcion': estudiante['description'] ?? "No disponible",
          'email': estudiante['userProfile'] != null
              ? "${estudiante['userProfile']['email']}"
              : "No disponible",
        });
      }
      return estudiantes;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
