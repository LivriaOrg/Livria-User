// lib/features/communities/domain/repositories/community_repository.dart

import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';

abstract class CommunityRepository {
  Future<List<Community>> fetchCommunityList(int offset, int limit);
  Future<List<Post>> fetchPostsByCommunityId(int communityId, int offset, int limit);
  Future<Post> fetchPostById(int id);
  Future<List<Community>> searchCommunities(String query);
}