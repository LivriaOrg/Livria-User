import 'package:http/http.dart' as http;

import '../../../../common/config/api_config.dart';

class BookRemoteDataSource {
  final http.Client _client;
  BookRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  Uri _u(String path) => Uri.parse('${apiBase()}$path');

  Future<http.Response> getAllBooks() => _client.get(_u('/api/v1/books'));
  Future<http.Response> getBook(int id) => _client.get(_u('/api/v1/books/$id'));
  Future<http.Response> addStock(int id, int qty) =>
      _client.put(_u('/api/v1/books/$id/stock'),
          headers: {'Content-Type': 'application/json'},
          body: '{"quantityToAdd": $qty}');
}
