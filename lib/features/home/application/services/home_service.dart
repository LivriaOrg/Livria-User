// lib/features/home/application/services/home_service.dart

import 'package:livria_user/features/book/application/services/book_service.dart';
import 'package:livria_user/features/book/domain/entities/book.dart';


class HomeService {
  final BookService _bookService;

  const HomeService(this._bookService);

  Future<List<Book>> getNewReleases() async {
    final allBooks = await _bookService.getAllBooks();

    return allBooks.toList();
  }

  Future<List<String>> getAllGenres() {
    return _bookService.getGenres();
  }
}