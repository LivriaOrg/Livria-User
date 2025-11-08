import 'package:http/http.dart' as http;
import 'package:livria_user/common/config/env.dart';

import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';

class ReviewRemoteDataSource {
  static const String _base = Env.apiBase;
  static const String _reviewsPath = '/api/v1/reviews';

  final http.Client _client;
  // Añadir la dependencia al local data source para obtener el token
  final AuthLocalDataSource _authDs;

  ReviewRemoteDataSource({http.Client? client, AuthLocalDataSource? authDs})
      : _client = client ?? http.Client(),
        _authDs = authDs ?? AuthLocalDataSource();

  Future<http.Response> getAllReviews() {
    final uri = Uri.parse('$_base$_reviewsPath');
    return _client.get(uri);
  }

  Future<http.Response> getBookReviews(int id) async {
    final uri = Uri.parse('$_base$_reviewsPath/book/$id');
    final token = await _authDs.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Error 401: Token de autorización no encontrado.');
    }

    return _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // El formato 'Bearer [token]' es requerido por tu Swagger/API
        'Authorization': 'Bearer $token',
      },
    );
  }
}