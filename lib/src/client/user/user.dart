import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/comment/comment.dart';
import 'package:lemmy_dart_client/src/client/comment/comment_helper.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';
import 'package:lemmy_dart_client/src/client/post/post_helper.dart';

/// This class defines a series of actions that can be performed on a given user.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Initialize the user and fetch the user information
/// final user = await User.initialize(client, id: '1');
/// final user = await User.initialize(client, username: 'username');
///
/// // Fetch the posts for the user
/// final posts = await user.posts(sort: 'Active', limit: 10);
///
/// // Fetch the comments for the user
/// final comments = await user.comments(sort: 'Active', limit: 10);
/// ```
class User {
  /// The client instance.
  final LemmyClient _client;

  /// The user id.
  int? id;

  /// The user username.
  String? username;

  /// The internal user information. This should be updated whenever the user information changes.
  Map<String, dynamic>? _user;

  /// Private constructor for creating a User instance.
  User._(this._client);

  /// Initializes a new user instance.
  /// If [id] or [username] is provided, the user information will be fetched from the API.
  ///
  /// If [user] is provided, the user information will be used instead of fetching it from the API.
  static Future<User> initialize(LemmyClient client, {int? id, String? username, Map<String, dynamic>? user}) async {
    final instance = User._(client);

    // If the user information is pre-fetched, use it.
    if (user != null && user.containsKey('person_view')) {
      instance._user = user;
      instance.id = user['person_view']['person']['id'];
      instance.username = user['person_view']['person']['name'];
      return instance;
    }

    // Otherwise, fetch the user information from its id or username.
    assert((id == null) != (username == null), 'Exactly one of id or username must be provided');
    instance.id = id;
    instance.username = username;

    await instance.info();
    instance.id = instance._user?['person_view']['person']['id'];
    instance.username = instance._user?['person_view']['person']['name'];

    return instance;
  }

  /// Fetches the information of the given user.
  Future<Map<String, dynamic>> info({bool refresh = false}) async {
    if (!refresh && _user != null) return _user!;

    final endpoint = '/person';

    final result = await _client.sendGetRequest(
      path: endpoint,
      body: {
        'person_id': id,
        'name': username,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    // Update the internal user information.
    _user = jsonDecode(result.body);
    return _user!;
  }

  /// Gets the current user's posts.
  Future<PostListResult> posts({
    String? sort,
    int? limit,
    String? cursor,
  }) async {
    final endpoint = '/person/content';

    final response = await _client.sendGetRequest(
      path: endpoint,
      body: {
        'type_': "Posts",
        'person_id': id,
        'sort': sort,
        'limit': limit,
        'page_cursor': cursor,
      },
    );

    if (response.statusCode != 200) throw Exception(jsonDecode(response.body)['error']);

    final result = jsonDecode(response.body);
    final postsData = result['content'] as List<dynamic>;

    final posts = await Future.wait(
      postsData.map((post) async {
        final postId = post['post']['id'] as int;
        return Post.initialize(_client, id: postId, post: {'post_view': post});
      }),
    );

    return PostListResult(
      posts: posts,
      nextCursor: result['next_cursor'],
      prevCursor: result['prev_cursor'],
    );
  }

  /// Gets the current user's comments.
  Future<CommentListResult> comments({
    String? sort,
    int? limit,
    String? cursor,
  }) async {
    final endpoint = '/person/content';

    final response = await _client.sendGetRequest(
      path: endpoint,
      body: {
        'type_': "Comments",
        'person_id': id,
        'sort': sort,
        'limit': limit,
        'page_cursor': cursor,
      },
    );

    if (response.statusCode != 200) throw Exception(jsonDecode(response.body)['error']);

    final result = jsonDecode(response.body);
    final commentsData = result['content'] as List<dynamic>;

    final comments = await Future.wait(
      commentsData.map((comment) async {
        final commentId = comment['comment']['id'] as int;
        return Comment.initialize(_client, id: commentId, comment: {'comment_view': comment});
      }),
    );

    return CommentListResult(
      comments: comments,
      nextCursor: result['next_cursor'],
      prevCursor: result['prev_cursor'],
    );
  }
}
