// lib/features/communities/application/services

// packages
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http; // http requests

// entities
import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';

class CommunityService {
  // crear constants porfavor :d
  static final String _baseUrl = 'urlbaseconstante';

  Future<List<Community>> fetchCommunityList({
    required int offset,
    required int limit,
  }) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/communities?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);

      final List<dynamic> communityJsonList = responseJson['items'] as List;

      final communityList = communityJsonList.map((jsonItem) {
        return Community.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();

      return communityList;
    } else {
      throw Exception('Fallo al cargar la lista de comunidades');
    }
  }

  Future<Community> _fetchCommunityById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/communities/$id'));

    if (response.statusCode == 200) {
      return Community.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar la comunidad con la ID: $id');
    }
  }

  Future<List<Post>> fetchPostsByCommunityId({
    required int communityId,
    required int offset,
    required int limit,
  }) async {
    final url = '$_baseUrl/posts/community/$communityId?offset=$offset&limit=$limit';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);

      // verificar (0 )(0 )
      final List<dynamic> postsJsonList = responseJson['posts'] as List;

      final postsList = postsJsonList.map((jsonItem) {
        return Post.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();

      return postsList;
    } else if (response.statusCode == 404) {
      throw Exception('Comunidad no encontrada o sin posts.');
    } else {
      throw Exception('Fallo al cargar los posts de la comunidad: ${response.statusCode}');
    }
  }
}
