import 'dart:convert';             // para convertir entre JSON y Map
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../../../../common/utils/constants.dart';

//clase que maneja la comunicación con el backend para autenticación
class AuthRemoteDataSource {
  final String _baseUrl = Constants.apiBaseUrl;

  // cliente HTTP
  final http.Client client;
  AuthRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  // --- Iniciar sesión con username y password ---
  Future<Map<String, dynamic>> signIn(String username, String password) async {
    // construye la URL del endpoint de login
    final url = Uri.parse('$_baseUrl/authentication/sign-in/client');

    // hace una petición POST al endpoint con los datos de login
    final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password
        })
    );

    // si el backend responde OK (200), decodifica el JSON y lo devuelve
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en Login: ${response.body}');
    }
  }

  // --- Obtener perfil de usuario autenticado ---
  Future<UserModel> getUserProfile(int userId, String token) async {
    final url = Uri.parse('$_baseUrl/userclients/$userId');

    // petición GET con token de autorización
    final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // token JWT
        }
    );

    // si la respuesta es correcta, convierte JSON a UserModel
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Error obteniendo perfil: ${response.body}');
    }
  }

  // --- Registrar un nuevo usuario ---
  Future<void> register(Map<String, dynamic> registerData) async {
    final url = Uri.parse('$_baseUrl/authentication/register');

    // petición POST con los datos de registro
    final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registerData)
    );

    debugPrint("🔵 URL: $url");
    debugPrint("📦 BODY: ${jsonEncode(registerData)}");
    debugPrint("🟣 RESPUESTA DEL SERVIDOR: ${response.statusCode}");
    debugPrint("🟣 CUERPO RESPUESTA: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return; // no devuelve nada, solo indica éxito
    } else {
      throw Exception('Error en Registro: ${response.body}');
    }
  }
}
