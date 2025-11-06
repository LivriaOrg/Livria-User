// lib/features/communities/application/services

// packages
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http; // http requests

// entities
import '../../domain/entities/community.dart';
import '../../domain/entities/post.dart';

class CommunityService {
  static final String _baseUrl = 'https://livriagod.azurewebsites.net/';

  Future<List<Community>> fetchCommunityList({
    required int offset,
    required int limit,
  }) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/communities?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> communityJsonList = jsonDecode(response.body);

      final communityList = communityJsonList.map((jsonItem) {
        return Community.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();

      return communityList;
    } else {
      throw Exception('Fallo al cargar la lista de comunidades');
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
      // JSON es una Lista (List<dynamic>) directamente, NO un Map con clave '0'
      final List<dynamic> postsJsonList = jsonDecode(response.body);

      final postsList = postsJsonList.map((jsonItem) {
        // Mapeo a la entidad Post (ya corregida)
        return Post.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();

      return postsList;
    } else if (response.statusCode == 404) {
      throw Exception('Comunidad no encontrada o sin posts.');
    } else {
      throw Exception('Fallo al cargar los posts de la comunidad: ${response.statusCode}');
    }
  }

  Future<Post> _fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/posts/$id'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el post con la ID: $id');
    }
  }

}