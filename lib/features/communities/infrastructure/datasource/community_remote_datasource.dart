import 'package:http/http.dart' as http;
import 'package:livria_user/common/config/env.dart';

class CommunityRemoteDataSource {
  static const String _base = Env.apiBase;
  static const String _communitiesPath = '/communities';
  static const String _postsPath = '/posts';

  final http.Client _client;
  CommunityRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  // communities
  Future<http.Response> fetchCommunityList(int offset, int limit) {
    final uri = Uri.parse('$_base$_communitiesPath?offset=$offset&limit=$limit');
    return _client.get(uri);
  }

  Future<http.Response> fetchCommunityById(int id) {
    final uri = Uri.parse('$_base$_communitiesPath/$id');
    return _client.get(uri);
  }

  // posts
  Future<http.Response> fetchPostsByCommunityId(int communityId, int offset, int limit) {
    final uri = Uri.parse('$_base$_postsPath/community/$communityId?offset=$offset&limit=$limit');
    return _client.get(uri);
  }

  Future<http.Response> fetchPostById(int id) {
    final uri = Uri.parse('$_base$_postsPath/$id');
    return _client.get(uri);
  }
}