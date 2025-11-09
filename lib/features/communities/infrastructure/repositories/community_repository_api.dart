import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/joined_community.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasource/community_remote_datasource.dart';

class CommunityRepositoryApi implements CommunityRepository {
  final CommunityRemoteDataSource _dataSource;

  const CommunityRepositoryApi({required CommunityRemoteDataSource dataSource})
      : _dataSource = dataSource;

  // --- Mappers ---

  Community _mapCommunity(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(responseBody);
      return Community.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to parse community JSON: $e');
    }
  }

  List<Community> _mapCommunityList(String responseBody) {
    try {
      final List<dynamic> jsonList = json.decode(responseBody);
      return jsonList.map((json) => Community.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to parse community list JSON: $e');
    }
  }

  JoinedCommunity _mapJoinedCommunity(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(responseBody);
      return JoinedCommunity.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to parse joined community JSON: $e');
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

  @override
  Future<List<Community>> fetchCommunityList(int offset, int limit) async {
    final http.Response response = await _dataSource.fetchCommunityList(offset, limit);

    if (response.statusCode == 200) {
      return _mapCommunityList(response.body);
    } else {
      throw Exception('Failed to load communities. Status: ${response.statusCode}');
    }
  }

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
  Future<Community> createCommunity({
    required String name,
    required String description,
    required int type,
    required String image,
    required String banner,
  }) async {
    final body = {
      "name": name,
      "description": description,
      "type": type,
      "image": image,
      "banner": banner,
    };

    final http.Response res = await _dataSource.createCommunity(body);

    if (res.statusCode == 201) {
      return _mapCommunity(res.body);
    }
    throw Exception('HTTP ${res.statusCode}: Fallo al crear la comunidad. Mensaje: ${res.body}');
  }

  // --- IMPLEMENTACIONES DE UNIÓN Y SALIDA ---

  @override
  Future<JoinedCommunity> joinCommunity({
    required int userClientId,
    required int communityId,
  }) async {
    final body = {
      "userClientId": userClientId,
      "communityId": communityId,
    };

    // Suponiendo que _dataSource.joinCommunity hace el POST a /api/v1/communities/join
    final http.Response res = await _dataSource.joinCommunity(body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      // Mapeamos la respuesta del servidor al objeto JoinedCommunity
      return _mapJoinedCommunity(res.body);
    }
    // Si la respuesta no es 200/201, lanzamos un error
    throw Exception('HTTP ${res.statusCode}: Fallo al unirse a la comunidad. Mensaje: ${res.body}');
  }

  @override
  Future<void> leaveCommunity({
    required int userClientId,
    required int communityId,
  }) async {
    // Suponiendo que _dataSource.leaveCommunity hace el DELETE a /api/v1/communities/{communityId}/members/{userId}
    final http.Response res = await _dataSource.leaveCommunity(
      communityId: communityId,
      userId: userClientId,
    );

    // DELETE a menudo devuelve 200 (OK) o 204 (No Content)
    if (res.statusCode == 200 || res.statusCode == 204) {
      return; // Éxito, no se espera cuerpo de respuesta
    }

    // Si la respuesta no es 200/204, lanzamos un error
    throw Exception('HTTP ${res.statusCode}: Fallo al salir de la comunidad. Mensaje: ${res.body}');
  }
}