import 'package:livria_user/features/book/domain/repositories/review_repository_impl.dart';

import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewService {
  final ReviewRepository _repos;
  const ReviewService(this._repos);

  Future<List<Review>> getAllReviews() => _repos.getAll();

  Future<List<Review>> getBookReviews(int id) => _repos.getBookReviews(id);

}
