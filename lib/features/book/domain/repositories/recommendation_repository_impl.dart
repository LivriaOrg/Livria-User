import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:math';

import '../entities/book.dart';
import 'recommendation_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/book_remote_datasource.dart';
import 'package:livria_user/features/book/infrastructure/datasource/recommendation_remote_datasource.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_local_datasource.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource _recommendationDs;
  final AuthLocalDataSource _authDs;
  final BookRemoteDataSource _bookDs;

  const RecommendationRepositoryImpl(this._recommendationDs, this._authDs, this._bookDs);

  @override
  Future<List<Book>> getRecommendedBooks() async {
    final int? userId = await _authDs.getUserId();

    if (userId != null) {
      final http.Response res = await _recommendationDs.getRecommendedBooks(userId);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> responseJson = json.decode(res.body);
        final List<dynamic> bookListJson = responseJson['recommendedBooks'] as List<dynamic>;
        return Book.listFromJson(json.encode(bookListJson));
      } else {
        throw Exception('HTTP ${res.statusCode}: Fallo al obtener recomendaciones. ${res.reasonPhrase}');
      }
    }

    final http.Response allBooksRes = await _bookDs.getAllBooks();
    if (allBooksRes.statusCode >= 200 && allBooksRes.statusCode < 300) {
      final allBooks = Book.listFromJson(allBooksRes.body);

      if (allBooks.length <= 6) {
        return allBooks;
      }

      final List<Book> shuffled = List.from(allBooks);
      shuffled.shuffle(Random());
      return shuffled.take(6).toList();
    }

    throw Exception('No se pudo obtener la lista de libros aleatorios para el fallback.');
  }
}