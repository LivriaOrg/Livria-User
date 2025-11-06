// lib/features/communities/domain/entities

// /api/v1/communities/ + id
// /api/v1/posts/community/ + communityId

import 'post.dart';

class Community {
  final int id;
  final String name;
  final String description;
  final String type;
  final String image;
  final String banner;
  final List<Post> posts;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.image,
    required this.banner,
    required this.posts,
  });

  factory Community.fromJson(Map<String,dynamic> json) {
    // Post es una entidad, se debe mapear para agregarlo a la lista
    final List<dynamic> postsJson = json['posts'] ?? [];

    final List<Post> postsList = postsJson.map((postJson) {
      return Post.fromJson(postJson as Map<String, dynamic>);
    }).toList();

  return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      image: json['image'],
      banner: json['banner'],
      posts: postsList
    );
  }
}