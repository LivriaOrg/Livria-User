// lib/features/communities/application/services/community_service.dart

import '../../domain/entities/community.dart';
import '../../domain/repositories/community_repository.dart';

class CommunityService {
  final CommunityRepository _repo;

  const CommunityService(this._repo);

  Future<List<Community>> getCommunityList(int offset, int limit) =>
      _repo.fetchCommunityList(offset, limit);

  Future<List<Community>> findCommunities(String query) =>
      _repo.searchCommunities(query);
}