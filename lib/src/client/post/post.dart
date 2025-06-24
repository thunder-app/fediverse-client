import 'dart:convert';

import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/comment/comment.dart';
import 'package:fediverse_client/src/client/comment/comment_helper.dart';

/// This class defines a series of actions that can be performed on a given post.
///
/// Usage:
/// ```dart
/// final client = await FediverseClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch the post information
/// final post = await client.post(id: 1);
/// final postInformation = await client.post(id: 1).info();
/// ```
class Post {
  /// The client instance.
  final FediverseClient _client;

  /// The post id.
  int? id;

  /// The internal post information. This should be updated whenever the post information changes.
  Map<String, dynamic>? _post;

  /// Private constructor for creating a Post instance.
  Post._(this._client);

  /// Initializes a new post instance.
  /// If [id] is provided, the post information will be fetched from the API.
  ///
  /// If [post] is provided, the post information will be used instead of fetching it from the API.
  static Future<Post> initialize(FediverseClient client, {int? id, Map<String, dynamic>? post}) async {
    final instance = Post._(client);

    // If the post information is pre-fetched, use it.
    if (post != null && post.containsKey('post_view')) {
      instance._post = post;
      instance.id = post['post_view']['post']['id'];
      return instance;
    }

    // Otherwise, fetch the post information from its id.
    assert(id != null, 'id must be provided');
    instance.id = id;

    await instance.info();
    instance.id = instance._post?['post_view']['post']['id'];

    return instance;
  }

  /// Fetches the information of the given post.
  Future<Map<String, dynamic>> info({bool refresh = false}) async {
    if (!refresh && _post != null) return _post!;

    final endpoint = '/post';

    final result = await _client.sendGetRequest(
      path: endpoint,
      body: {'id': id},
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    // Update the internal post information.
    _post = jsonDecode(result.body);
    return _post!;
  }

  /// Edits the given post.
  Future<Post> edit({
    String? name,
    String? url,
    String? body,
    String? altText,
    bool? nsfw,
    int? languageId,
    String? thumbnailUrl,
    List<int>? tags,
    DateTime? scheduledAt,
  }) async {
    final endpoint = '/post';

    final result = await _client.sendPutRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'name': name,
        'url': url,
        'body': body,
        'alt_text': body,
        'nsfw': nsfw,
        'language_id': languageId,
        'custom_thumbnail': thumbnailUrl,
        'tags': tags,
        if (scheduledAt != null) 'scheduled_publish_time': scheduledAt.millisecondsSinceEpoch ~/ 1000,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Submits a new reply (comment) to the given post.
  Future<Comment> reply({
    required String content,
    int? languageId,
  }) async {
    final endpoint = '/comment';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'content': content,
        'language_id': languageId,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final comment = jsonDecode(result.body);
    return Comment.initialize(_client, comment: comment);
  }

  /// Fetches the comments for the given post.
  Future<CommentListResult> comments({
    String? sort,
    String? cursor,
    int? limit,
  }) async {
    final endpoint = '/comment/list';

    final result = await _client.sendGetRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'sort': sort,
        'page_cursor': cursor,
        'limit': limit,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    final commentsData = response['comments'] as List<dynamic>;

    final comments = await Future.wait(
      commentsData.map((comment) async {
        final commentId = comment['comment']['id'] as int;
        return Comment.initialize(_client, id: commentId, comment: {'comment_view': comment});
      }),
    );

    return CommentListResult(
      comments: comments,
      nextCursor: response['next_cursor'],
      prevCursor: response['prev_cursor'],
    );
  }

  /// Deletes the given post.
  Future<Post> delete() async {
    final endpoint = '/post/delete';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'deleted': true,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Restores the given post.
  Future<Post> restore() async {
    final endpoint = '/post/delete';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'deleted': false,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Removes the given post. This is a moderator action.
  Future<Post> remove({required String reason}) async {
    final endpoint = '/post/remove';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'removed': true,
        'reason': reason,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Recovers a previously removed post. This is a moderator action.
  Future<Post> recover({required String reason}) async {
    final endpoint = '/post/remove';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'removed': false,
        'reason': reason,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Votes on the given post.
  Future<Post> vote({
    required int score,
  }) async {
    final endpoint = '/post/like';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'score': score,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Saves the given post.
  Future<Post> save() async {
    final endpoint = '/post/save';

    final result = await _client.sendPutRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'save': true,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Unsaves the given post.
  Future<Post> unsave() async {
    final endpoint = '/post/save';

    final result = await _client.sendPutRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'save': false,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Reads the given post.
  Future<Post> read() async {
    final endpoint = '/post/mark_as_read';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'read': true,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Unreads the given post.
  Future<Post> unread() async {
    final endpoint = '/post/mark_as_read';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'read': false,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Hides the given post.
  Future<Post> hide() async {
    final endpoint = '/post/hide';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'hide': true,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Unhides the given post.
  Future<Post> unhide() async {
    final endpoint = '/post/hide';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'hide': false,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Locks the given post.
  Future<Post> lock({String? reason}) async {
    final endpoint = '/post/lock';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'locked': true,
        'reason': reason,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Unlocks the given post.
  Future<Post> unlock({String? reason}) async {
    final endpoint = '/post/lock';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': id,
        'locked': false,
        'reason': reason,
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: id, post: response);
  }

  /// Reports the given post.
  /// TODO: Fix return type - it returns a post report instead of a post
  // Future<Post> report({required String reason}) async {
  //   final endpoint = '/post/report';

  //   final result = await _client.sendPostRequest(
  //     path: endpoint,
  //     body: {
  //       'post_id': id,
  //       'reason': reason,
  //     },
  //   );

  //   if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

  //   final response = jsonDecode(result.body);
  //   return Post.initialize(_client, id: id, post: response);
  // }
}
