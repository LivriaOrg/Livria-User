import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/community.dart';
import '../../domain/entities/joined_community.dart'; // Importamos JoinedCommunity
import '../../domain/repositories/community_repository.dart';
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

    final http.Response res = await _ds.createCommunity(body);

    if (res.statusCode == 201) { // 201 Created es una respuesta típica para POST
      final Map<String, dynamic> communityJson = jsonDecode(res.body);
      return Community.fromJson(communityJson);
    }
    // Lanza una excepción para indicar el error en la creación
    throw Exception('HTTP ${res.statusCode}: Fallo al crear la comunidad. Mensaje: ${res.body}');
  }

  // --- Implementaciones de Unirse y Salir (Join & Leave) ---

  @override
  Future<JoinedCommunity> joinCommunity({
    required int userClientId,
    required int communityId,
  }) async {
    final body = {
      "userClientId": userClientId,
      "communityId": communityId,
    };

    // Llama al método del DataSource para realizar el POST a /api/v1/communities/join
    final http.Response res = await _ds.joinCommunity(body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      // Mapea la respuesta JSON a JoinedCommunity
      final Map<String, dynamic> joinedJson = jsonDecode(res.body);
      return JoinedCommunity.fromJson(joinedJson);
    }
    throw Exception('HTTP ${res.statusCode}: Fallo al unirse a la comunidad. Mensaje: ${res.body}');
  }

  @override
  Future<void> leaveCommunity({
    required int userClientId,
    required int communityId,
  }) async {
    // Llama al método del DataSource para realizar el DELETE
    final http.Response res = await _ds.leaveCommunity(
      communityId: communityId,
      userId: userClientId,
    );

    // Un DELETE exitoso devuelve típicamente 200 o 204
    if (res.statusCode == 200 || res.statusCode == 204) {
      return;
    }

    throw Exception('HTTP ${res.statusCode}: Fallo al salir de la comunidad. Mensaje: ${res.body}');
  }
}