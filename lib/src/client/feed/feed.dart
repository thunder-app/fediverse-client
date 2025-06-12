import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';
import 'package:lemmy_dart_client/src/client/post/post_helper.dart';

/// This class defines a series of actions that can be performed on a given feed.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch the posts for the feed
/// final posts = await client.feed(type: 'All').posts(sort: 'Active', limit: 10);
/// ```
class Feed {
  /// The client instance.
  final LemmyClient _client;

  /// The feed type.
  final String type;

  /// Private constructor for creating a Feed instance.
  Feed(this._client, {required this.type});

  /// Fetches the posts for the given feed.
  ///
  /// A optional [sort] can be provided to sort the posts.
  /// A optional [cursor] can be provided to fetch the posts after the given cursor.
  /// A optional [limit] can be provided to limit the number of posts returned.
  Future<PostListResult> posts({
    String? sort,
    String? cursor,
    int? limit,
  }) async {
    final endpoint = '/post/list';

    final result = await _client.sendGetRequest(
      path: endpoint,
      body: {
        'type_': type,
        'sort': sort,
        'page_cursor': cursor,
        'limit': limit,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    final postsData = response['posts'] as List<dynamic>;

    // Create Post objects from the post data
    final posts = await Future.wait(
      postsData.map((post) async {
        final postId = post['post']['id'] as int;
        return Post.initialize(_client, id: postId, post: {'post_view': post});
      }),
    );

    return PostListResult(
      posts: posts,
      nextCursor: response['next_page'] as String?,
      prevCursor: response['prev_page'] as String?,
    );
  }
}
