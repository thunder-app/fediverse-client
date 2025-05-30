import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';

/// This class defines a series of actions that can be performed on a given post.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch the post information
/// final postInformation = await client.post(id: 1).info();
///
/// // Fetch the comments for the post
/// final comments = await client.post(id: 1).comments(sort: 'New', limit: 10);
/// ```
class Post {
  /// The client instance.
  final LemmyClient _client;

  /// The post id.
  final String id;

  /// Initializes a new post with the given id.
  Post(this._client, {required this.id});

  /// Fetches the information of the given post.
  Future<Map<String, dynamic>> info() async {
    final endpoint = '/post';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'id': id,
    });

    return jsonDecode(result.body);
  }

  /// Fetches the comments for the given post.
  Future<Map<String, dynamic>> comments({
    String? sort,
    String? cursor,
    int? limit,
  }) async {
    final endpoint = '/comment/list';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'post_id': id,
      'sort': sort,
      'page_cursor': cursor,
      'limit': limit,
    });

    return jsonDecode(result.body);
  }
}
