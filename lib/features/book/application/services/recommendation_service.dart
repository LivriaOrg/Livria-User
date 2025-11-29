import '../../domain/entities/book.dart';
import '../../domain/repositories/recommendation_repository.dart';

class RecommendationService {
  final RecommendationRepository _repository;

  const RecommendationService(this._repository);

  Future<List<Book>> getRecommendedBooks() {
    return _repository.getRecommendedBooks();
  }
}