abstract class FavoriteRepository {
  Future<void> addToFavorites({
    required int userId,
    required int bookId,
  });

  Future<void> removeFromFavorites({
    required int userId,
    required int bookId,
  });

  Future<bool> checkIsFavorite({
    required int userId,
    required int bookId,
  });
}