import 'package:http/http.dart' as http;
import 'package:livria_user/common/config/env.dart';

class ReviewRemoteDataSource {
  static const String _base = Env.apiBase;
  static const String _reviewsPath = '/api/v1/reviews';

  final http.Client _client;
  ReviewRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> getAllReviews() {
    final uri = Uri.parse('$_base$_reviewsPath');
    return _client.get(uri);
  }

  Future<http.Response> getBookReviews(int id) {
    final uri = Uri.parse('$_base$_reviewsPath/book/$id');
    return _client.get(uri);
  }
}