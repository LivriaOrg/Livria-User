// lib/features/communities/domain/entities

// /api/v1/posts/ + id

class Post {
  final int id;
  final int communityId;
  final int userId;
  final String content;
  final String image;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.content,
    required this.image,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // formatear DateTime
    final DateTime parsedDate = DateTime.parse(json['createdAt']);

    return Post(
        id: json['id'],
        communityId: json['communityId'],
        userId: json['userId'],
        content: json['content'],
        image: json['img'],
        createdAt: parsedDate
    );
  }
}