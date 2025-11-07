import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getAll();
  Future<List<Review>> getBookReviews(int id);
}