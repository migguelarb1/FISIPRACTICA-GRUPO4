import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_app/core/utils/dio.dart';
import 'package:flutter_app/features/auth/services/user_services.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ReclutadoresServices {
  static Future<Map<String, dynamic>> registerReclutador(
      body, File? photo) async {
    try {
      logger.d(body);
      final firstName = body['first_name'];
      final lastName = body['last_name'];
      final email = body['email'];
      final password = body['password'];
      final companyId = body['company_id'];
      final description = body['description'];
      final fechaInicio = body['position_start_date'];
      String? token = await UserServices.getToken();
      Response response = await dio.post(
        '/recruiter',
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
          'company_id': companyId,
          'description': description,
          'position_start_date': fechaInicio,
          'photo': photo != null
              ? await MultipartFile.fromFile(photo.path,
                  filename: photo.path.split('/').last)
              : null,
        }),
      );
      return response.data;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getReclutadorByUserId(int id) async {
    try {
      List<Map<String, dynamic>> reclutadores = await getReclutadores();
      for (var reclutador in reclutadores) {
        if (reclutador['user_id'] == id) {
          return reclutador;
        }
      }
      throw Exception('Reclutador not found');
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getReclutadores() async {
    try {
      String? token = await UserServices.getToken();
      Response response = await dio.get(
        '/recruiter',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(response);
      List<Map<String, dynamic>> reclutadores = [];
      for (var reclutador in response.data) {
        Uint8List? foto;
        if (reclutador['userProfile'] != null &&
            reclutador['userProfile']['photo'] != null) {
          foto = Uint8List.fromList(
              (reclutador['userProfile']['photo']['data'] as List<dynamic>)
                  .cast<int>());
        }
        reclutadores.add({
          'id': reclutador['id'],
          'nombre': reclutador['userProfile'] != null
              ? reclutador['userProfile']['first_name']
              : "No disponible",
          'apellido': reclutador['userProfile'] != null
              ? reclutador['userProfile']['last_name']
              : "No disponible",
          'correo': reclutador['userProfile'] != null
              ? reclutador['userProfile']['email']
              : "No disponible",
          'descripcion': reclutador['description'] ?? "No disponible",
          'fecha_inicio': reclutador['position_start_date'] != null
              ? '${DateTime.parse(reclutador['position_start_date']).day.toString().padLeft(2, '0')}/${DateTime.parse(reclutador['position_start_date']).month.toString().padLeft(2, '0')}/${DateTime.parse(reclutador['position_start_date']).year}'
              : "No disponible",
          'foto': foto,
          'empresa': reclutador['company']['name'],
          'empresa_id': reclutador['company']['id'],
          'color': reclutador['company']['color'],
          'user_id': reclutador['userProfile']['id'],
        });
      }
      return reclutadores;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  // Aquí agregamos el método registrarVacante
  static Future<bool> registrarVacante(Map<String, dynamic> vacante) async {
    try {
      String? token = await UserServices.getToken();

      // Crear el cuerpo de la solicitud según el DTO
      Map<String, dynamic> body = {
        "title": vacante["titulo"], // Cambiar los nombres según el DTO
        "location": vacante["ubicacion"],
        "description": vacante["descripcion"],
        "salary": vacante["salario"], // Asegúrate de tener este campo
        "url_job_pdf": vacante["url_job_pdf"], // Si lo tienes
        "job_requirements": vacante["requisitos"],
        "job_functions": vacante["funciones_trabajo"], // Si lo tienes
        "company_id": vacante["empresa_id"], // Cambiar si es diferente
        "user_creator_id": vacante["user_creator_id"],
      };

      // Realizamos la solicitud POST
      Response response = await dio.post(
        '/job', // URL para crear la vacante
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: body,
      );

      return response.statusCode ==
          201; // Retorna true si la vacante fue guardada exitosamente
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<int> getReclutadorById(int id) async {
    try {
      String? token = await UserServices.getToken();
      Response response = await dio.get(
        '/recruiter/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(response);
      var reclutador = response.data;
      Uint8List? foto;
      if (reclutador['userProfile'] != null &&
          reclutador['userProfile']['photo'] != null) {
        foto = Uint8List.fromList(
            (reclutador['userProfile']['photo']['data'] as List<dynamic>)
                .cast<int>());
      }
      logger.d(reclutador);
      return reclutador['id'];
    } on DioException catch (e) {
      logger.e(e);
      return 0;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateReclutador(int id, body) async {
    try {
      logger.d(body);
      String? token = await UserServices.getToken();
      Response response = await dio.patch(
        '/recruiter/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        ),
        data: body,
      );
      return response.data;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
