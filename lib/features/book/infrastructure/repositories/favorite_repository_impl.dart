// lib/features/favorites/infrastructure/repositories/favorite_repository_impl.dart
import 'package:livria_user/features/book/domain/repositories/favorite_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/favorite_remote_datasource.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addToFavorites({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.postFavorite(
      userId: userId,
      bookId: bookId,
    );
  }

  @override
  Future<void> removeFromFavorites({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.deleteFavorite(
      userId: userId,
      bookId: bookId,
    );
  }

  @override
  Future<bool> checkIsFavorite({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.getFavoriteStatus(
      userId: userId,
      bookId: bookId,
    );
  }
}