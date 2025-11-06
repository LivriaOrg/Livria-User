import 'package:http/http.dart' as http;

import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/book_remote_datasource.dart';
class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource _ds;
  const BookRepositoryImpl(this._ds);

  @override
  Future<List<Book>> getAll() async {
    final http.Response res = await _ds.getAllBooks();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Book.listFromJson(res.body);
    }
    throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
  }
}
