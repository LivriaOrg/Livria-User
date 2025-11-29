import '../entities/book.dart';

abstract class RecommendationRepository {
  Future<List<Book>> getRecommendedBooks();
}