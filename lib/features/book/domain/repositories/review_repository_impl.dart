import 'package:http/http.dart' as http;
import 'package:livria_user/features/book/domain/repositories/review_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/review_remote_datasource.dart';

import '../../domain/entities/review.dart';


class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _ds;
  const ReviewRepositoryImpl(this._ds);

  @override
  Future<List<Review>> getAll() async {
    final http.Response res= await _ds.getAllReviews();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Review.listFromJson(res.body);
    }
    throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
  }

  @override
  Future<List<Review>> getBookReviews(int id) async {
    final http.Response res= await _ds.getBookReviews(id);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Review.listFromJson(res.body);
    }
    throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
  }

  @override
  Future<void> postReview({required int bookId, required String content, required int stars}) async {
    final http.Response res = await _ds.postReview(
      bookId: bookId,
      content: content,
      stars: stars,
    );

    if (res.statusCode == 201) { // 201 para un POST exitoso
      return;
    }
    if (res.statusCode == 401) {
      throw Exception('HTTP 401: Sesión expirada. Por favor, inicie sesión de nuevo.');
    }

    throw Exception('HTTP ${res.statusCode}: Error al publicar la reseña.');
  }
}
