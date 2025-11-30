import '../repositories/community_repository.dart';

/// Caso de uso para verificar si un usuario es miembro de una comunidad.
class CheckUserJoinedUseCase {
  final CommunityRepository _repository;

  CheckUserJoinedUseCase(this._repository);

  Future<bool> call({
    required int userId,
    required int communityId,
  }) async {
    return _repository.checkUserJoined(
      userId: userId,
      communityId: communityId,
    );
  }
}