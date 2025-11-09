import '../entities/post.dart';

abstract class PostRepository {
  /// Obtiene una lista de posts por ID de comunidad con paginación.
  Future<List<Post>> fetchPostsByCommunityId(int communityId, int offset, int limit);

  /// Obtiene un post individual por su ID.
  Future<Post> fetchPostById(int id);

  /// Crea un nuevo post en una comunidad.
  Future<Post> createPost({
    required int communityId,
    required String username,
    required String content,
    String? img,
  });
}