// lib/features/communities/domain/entities

// /api/v1/communities/ + id
// /api/v1/posts/community/ + communityId

import 'post.dart';

class Community {
  final int id;
  final String name;
  final String description;
  final int type;
  final String image;
  final String banner;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.image,
    required this.banner,
  });

  factory Community.fromJson(Map<String,dynamic> json) {

  return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      image: json['image'],
      banner: json['banner'],
    );
  }
}