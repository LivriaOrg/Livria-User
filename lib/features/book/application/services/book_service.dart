import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class BookService {
  final BookRepository _repo;
  const BookService(this._repo);

  Future<List<Book>> getAllBooks() => _repo.getAll();

  /// géneros únicos ordenados alfabéticamente (ignorando mayúsc/minúsc)
  Future<List<String>> getGenres() async {
    final list = await getAllBooks();
    final set = <String>{};
    for (final b in list) {
      if (b.genre.trim().isNotEmpty) set.add(b.genre.trim());
    }
    final genres = set.toList();
    genres.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return genres;
  }

  /// libros filtrados por género (case-insensitive)
  Future<List<Book>> getByGenre(String genre) async {
    final list = await getAllBooks();
    return list.where((b) => b.genre.toLowerCase() == genre.toLowerCase()).toList();
  }

  // buscar el libro por su id
  Future<Book?> findBookById(String bookId) async {
    final list = await getAllBooks();

    // 1. Convertir el String ID de la URL a INT
    final int? targetId = int.tryParse(bookId);
    if (targetId == null) return null;

    try {
      final book = list.firstWhere(
            (b) => b.id == targetId,
        orElse: () => throw StateError('Book not found'),
      );
      return book;
    } on StateError {
      return null;
    }
  }

}
