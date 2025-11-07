import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasource/community_remote_datasource.dart';

class CommunityRepositoryApi implements CommunityRepository {
  final CommunityRemoteDataSource _dataSource;

  const CommunityRepositoryApi({required CommunityRemoteDataSource dataSource})
      : _dataSource = dataSource;

  List<Community> _mapCommunityList(String responseBody) {
    try {
      final List<dynamic> jsonList = json.decode(responseBody);
      return jsonList.map((json) => Community.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to parse community list JSON: $e');
    }
  }

  Post _mapPost(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(responseBody);
      return Post.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to parse post JSON: $e');
    }
  }

  List<Post> _mapPostList(String responseBody) {
    try {
      final List<dynamic> jsonList = json.decode(responseBody);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to parse post list JSON: $e');
    }
  }

  // -----------------------------------------------------------------------


  // Método para obtener todas las comunidades (paginadas)
  @override
  Future<List<Community>> fetchCommunityList(int offset, int limit) async {
    final http.Response response = await _dataSource.fetchCommunityList(offset, limit);

    if (response.statusCode == 200) {
      return _mapCommunityList(response.body);
    } else {
      // Manejo de errores de la API
      throw Exception('Failed to load communities. Status: ${response.statusCode}');
    }
  }

  // Método usado para la búsqueda inicial y el filtrado
  @override
  Future<List<Community>> searchCommunities(String query) async {

    final http.Response response = await _dataSource.fetchCommunityList(0, 100);

    if (response.statusCode == 200) {
      final allCommunities = _mapCommunityList(response.body);

      if (query.isEmpty) {
        return allCommunities;
      }
      final normalizedQuery = query.toLowerCase().trim();
      return allCommunities.where((community) {
        return community.name.toLowerCase().contains(normalizedQuery) ||
            community.description.toLowerCase().contains(normalizedQuery);
      }).toList();

    } else {
      throw Exception('Failed to search communities. Status: ${response.statusCode}');
    }
  }


  @override
  Future<Post> fetchPostById(int id) async {
    final http.Response response = await _dataSource.fetchPostById(id);

    if (response.statusCode == 200) {
      return _mapPost(response.body);
    } else {
      throw Exception('Failed to load post $id. Status: ${response.statusCode}');
    }
  }

  @override
  Future<List<Post>> fetchPostsByCommunityId(int communityId, int offset, int limit) async {
    final http.Response response = await _dataSource.fetchPostsByCommunityId(communityId, offset, limit);

    if (response.statusCode == 200) {
      return _mapPostList(response.body);
    } else {
      throw Exception('Failed to load posts for community $communityId. Status: ${response.statusCode}');
    }
  }
}