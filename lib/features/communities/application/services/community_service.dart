// lib/features/communities/application/services/community_service.dart

import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';
import '../../infrastructure/repositories/community_repository.dart';

class CommunityService {
  final CommunityRepository _repo;

  const CommunityService(this._repo);

  Future<List<Community>> getCommunityList(int offset, int limit) =>
      _repo.fetchCommunityList(offset, limit);

  Future<List<Post>> getPostsForCommunity(int communityId, int offset, int limit) =>
      _repo.fetchPostsByCommunityId(communityId, offset, limit);

  Future<Post> getPost(int id) => _repo.fetchPostById(id);

  Future<List<Community>> findCommunities(String query) =>
      _repo.searchCommunities(query);
}