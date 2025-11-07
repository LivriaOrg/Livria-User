// lib/features/communities/domain/repositories/community_repository_impl.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/community.dart';
import '../entities/post.dart';
import 'community_repository.dart';
import '../../infrastructure/datasource/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _ds;

  const CommunityRepositoryImpl(this._ds);

  @override
  Future<List<Community>> fetchCommunityList(int offset, int limit) async {
    final http.Response res = await _ds.fetchCommunityList(offset, limit);

    if (res.statusCode == 200) {
      final List<dynamic> communityJsonList = jsonDecode(res.body);
      return communityJsonList.map((jsonItem) =>
          Community.fromJson(jsonItem as Map<String, dynamic>)).toList();
    }
    throw Exception('HTTP ${res.statusCode}: Fallo al cargar la lista de comunidades');
  }

  @override
  Future<List<Post>> fetchPostsByCommunityId(int communityId, int offset, int limit) async {
    final http.Response res = await _ds.fetchPostsByCommunityId(communityId, offset, limit);

    if (res.statusCode == 200) {
      final List<dynamic> postsJsonList = jsonDecode(res.body);
      return postsJsonList.map((jsonItem) =>
          Post.fromJson(jsonItem as Map<String, dynamic>)).toList();
    }
    if (res.statusCode == 404) {
      return [];
    }
    throw Exception('HTTP ${res.statusCode}: Fallo al cargar los posts.');
  }

  @override
  Future<List<Community>> searchCommunities(String query) async {
    const int maxLimit = 1000;
    final normalizedQuery = query.toLowerCase().trim();

    if (normalizedQuery.isEmpty) return [];

    final allCommunities = await fetchCommunityList(0, maxLimit);

    return allCommunities.where((community) {
      final nameMatches = community.name.toLowerCase().contains(normalizedQuery);
      final descriptionMatches = community.description.toLowerCase().contains(normalizedQuery);
      return nameMatches || descriptionMatches;
    }).toList();
  }

  @override
  Future<Post> fetchPostById(int id) async {
    final http.Response res = await _ds.fetchPostById(id);

    if (res.statusCode == 200) {
      return Post.fromJson(jsonDecode(res.body));
    }
    throw Exception('HTTP ${res.statusCode}: Error al cargar el post con la ID: $id');
  }
}