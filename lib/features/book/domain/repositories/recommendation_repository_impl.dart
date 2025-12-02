import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../entities/book.dart';
import 'recommendation_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/book_remote_datasource.dart';
import 'package:livria_user/features/book/infrastructure/datasource/recommendation_remote_datasource.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_local_datasource.dart';
import 'package:livria_user/features/book/domain/repositories/exclusion_repository.dart';


class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource _recommendationDs;
  final AuthLocalDataSource _authDs;
  final BookRemoteDataSource _bookDs;
  final ExclusionRepository _exclusionRepository;


  const RecommendationRepositoryImpl(
      this._recommendationDs,
      this._authDs,
      this._bookDs,
      this._exclusionRepository,
      );

  @override
  Future<List<Book>> getRecommendedBooks() async {
    final int? userId = await _authDs.getUserId();

    if (userId != null) {
      final http.Response res = await _recommendationDs.getRecommendedBooks(userId);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final Map<String, dynamic> responseJson = json.decode(res.body);
        final List<dynamic> bookListJson = responseJson['recommendedBooks'] as List<dynamic>;
        List<Book> recommendedBooks = Book.listFromJson(json.encode(bookListJson));
        return recommendedBooks;

      } else {
        print('Warning: Recommendation API failed (${res.statusCode}). Falling back to random books.');
      }
    }

    final http.Response allBooksRes = await _bookDs.getAllBooks();

    if (allBooksRes.statusCode >= 200 && allBooksRes.statusCode < 300) {
      List<Book> allBooks = Book.listFromJson(allBooksRes.body);

      List<int> excludedIds = [];

      if (userId != null) {
        excludedIds = await _exclusionRepository.getExcludedBookIds(userId: userId);
      }

      List<Book> availableBooks = allBooks.where((book) {
        return !excludedIds.contains(book.id);
      }).toList();


      if (availableBooks.length <= 6) {
        return availableBooks;
      }

      final List<Book> shuffled = List.from(availableBooks);
      shuffled.shuffle(Random());
      return shuffled.take(6).toList();
    }

    throw Exception('No se pudo obtener la lista de libros aleatorios para el fallback.');
  }
}