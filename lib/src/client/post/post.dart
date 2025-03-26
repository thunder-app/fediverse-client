import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

class Post {
  final LemmyClient _client;

  /// The post id.
  final int id;

  Post(this._client, {required this.id});

  Map<String, dynamic>? info;

  /// Refreshes the post information. This is used to fetch the entire post information from the server.
  ///
  /// When successful, the client's site information is also updated.
  Future<Map<String, dynamic>> refresh() async {
    final v4Endpoint = '/post';
    final result = await _client.sendGetRequest(
      path: getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version),
      body: {
        'id': id,
      },
    );

    info = result;
    return result;
  }
}
