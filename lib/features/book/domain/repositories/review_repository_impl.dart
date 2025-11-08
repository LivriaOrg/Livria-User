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

}
