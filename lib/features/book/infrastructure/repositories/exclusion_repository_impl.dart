import 'package:livria_user/features/book/domain/repositories/exclusion_repository.dart';
import 'package:livria_user/features/book/infrastructure/datasource/exclusion_remote_datasource.dart';


class ExclusionRepositoryImpl implements ExclusionRepository {
  final ExclusionRemoteDataSource remoteDataSource;

  ExclusionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addToExclusions({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.postExclusion(
      userId: userId,
      bookId: bookId,
    );
  }

  @override
  Future<void> removeFromExclusions({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.deleteExclusion(
      userId: userId,
      bookId: bookId,
    );
  }

  @override
  Future<bool> checkIsExcluded({
    required int userId,
    required int bookId,
  }) async {
    return remoteDataSource.getExclusionStatus(
      userId: userId,
      bookId: bookId,
    );
  }
}