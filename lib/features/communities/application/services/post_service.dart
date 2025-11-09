// lib/features/communities/application/services/community_service.dart

import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

class PostService {
  final PostRepository _repo;

  const PostService(this._repo);

  Future<List<Post>> getPostsForCommunity(int communityId, int offset, int limit) =>
      _repo.fetchPostsByCommunityId(communityId, offset, limit);

  Future<Post> getPost(int id) => _repo.fetchPostById(id);
}