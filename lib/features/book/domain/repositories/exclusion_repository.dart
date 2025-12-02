abstract class ExclusionRepository {
  Future<void> addToExclusions({
    required int userId,
    required int bookId,
  });

  Future<void> removeFromExclusions({
    required int userId,
    required int bookId,
  });

  Future<bool> checkIsExcluded({
    required int userId,
    required int bookId,
  });

  Future<List<int>> getExcludedBookIds({
    required int userId
  });
}