import '../../domain/entities/book.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/repositories/exclusion_repository.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import 'book_service.dart';


class RecommendationService {
  final RecommendationRepository _repository;
  final ExclusionRepository _exclusionRepository;
  final AuthLocalDataSource _authDs;
  final BookService _bookService;

  const RecommendationService(
      this._repository,
      this._exclusionRepository,
      this._authDs,
      this._bookService,
      );

  /// Obtiene la lista de libros recomendados, la filtra por exclusión,
  /// y usa libros aleatorios como fallback si la lista filtrada queda vacía.
  @override
  Future<List<Book>> getRecommendedBooks() async {
    final int? userId = await _authDs.getUserId();

    if (userId == null) {
      return _bookService.getRandomBooks();
    }

    final List<int> excludedBookIds = await _exclusionRepository.getExcludedBookIds(
      userId: userId,
    );

    List<Book> recommendedBooks = [];

    try {
      recommendedBooks = await _repository.getRecommendedBooks();
    } catch (e) {
      print('Error al obtener recomendaciones personalizadas: $e');
    }

    List<Book> filteredRecommendations = recommendedBooks.where((book) {
      return !excludedBookIds.contains(book.id);
    }).toList();

    if (filteredRecommendations.isEmpty) {
      print('La lista de recomendaciones filtrada está vacía. Activando fallback de libros aleatorios.');

      final List<Book> randomBooks = await _bookService.getRandomBooks();

      final List<Book> filteredRandomBooks = randomBooks.where((book) {
        return !excludedBookIds.contains(book.id);
      }).toList();

      return filteredRandomBooks;
    }

    return filteredRecommendations;
  }
}