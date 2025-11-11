// lib/features/home/application/services/home_service.dart

import 'package:livria_user/features/book/application/services/book_service.dart';
import 'package:livria_user/features/book/domain/entities/book.dart';


class HomeService {
  final BookService _bookService;

  const HomeService(this._bookService);

  /// Obtiene todos los libros y selecciona los 10 primeros (ejemplo de "Novedades").
  Future<List<Book>> getNewReleases() async {
    final allBooks = await _bookService.getAllBooks();

    return allBooks.take(10).toList();
  }

  /// Obtiene una lista de géneros para la navegación por categorías.
  Future<List<String>> getAllGenres() {
    return _bookService.getGenres();
  }
}