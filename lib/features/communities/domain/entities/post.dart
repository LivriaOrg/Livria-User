// lib/features/communities/domain/entities

// /api/v1/posts/ + id

class Post {
  final int id;
  final int communityId;
  final int userId;
  final String username;
  final String content;
  final String img;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.username,
    required this.content,
    required this.img,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // formatear DateTime
    final DateTime parsedDate = DateTime.parse(json['createdAt']);

    return Post(
        id: json['id'],
        communityId: json['communityId'],
        userId: json['userId'],
        username: json['username'],
        content: json['content'],
        img: json['img'],
        createdAt: parsedDate
    );
  }
}