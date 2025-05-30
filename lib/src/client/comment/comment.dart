import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';

/// This class defines a series of actions that can be performed on a given comment.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch a specific comment
/// final comment = await client.comment(id: 1).info();
/// ```
class Comment {
  /// The client instance.
  final LemmyClient _client;

  /// The comment id.
  final String id;

  /// Private constructor for creating a Comment instance.
  Comment(this._client, {required this.id});

  /// Fetches the information of the given comment.
  Future<Map<String, dynamic>> info() async {
    final endpoint = '/comment';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'id': id,
    });

    return jsonDecode(result.body);
  }
}
