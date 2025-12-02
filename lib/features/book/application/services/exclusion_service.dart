import 'package:livria_user/features/book/domain/repositories/exclusion_repository.dart';

class ExclusionService {
  final ExclusionRepository exclusionRepository;

  ExclusionService(this.exclusionRepository);

  Future<void> addExclusion({
    required int userId,
    required int bookId,
  }) async {
    await exclusionRepository.addToExclusions(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<void> removeExclusion({
    required int userId,
    required int bookId,
  }) async {
    await exclusionRepository.removeFromExclusions(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<bool> getIsExcludedStatus({
    required int userId,
    required int bookId,
  }) async {
    return exclusionRepository.checkIsExcluded(
      userId: userId,
      bookId: bookId,
    );
  }
}