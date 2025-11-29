import 'package:livria_user/features/book/domain/repositories/favorite_repository.dart';

class FavoriteService {
  final FavoriteRepository favoriteRepository;

  FavoriteService(this.favoriteRepository);

  Future<void> addFavorite({
    required int userId,
    required int bookId,
  }) async {

    await favoriteRepository.addToFavorites(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<void> removeFavorite({
    required int userId,
    required int bookId,
  }) async {
    await favoriteRepository.removeFromFavorites(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<bool> getIsFavoriteStatus({
    required int userId,
    required int bookId,
  }) async {
    return favoriteRepository.checkIsFavorite(
      userId: userId,
      bookId: bookId,
    );
  }
}