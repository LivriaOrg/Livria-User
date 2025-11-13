import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAll();
  Future<List<Book>> getRandomBooks();
}
