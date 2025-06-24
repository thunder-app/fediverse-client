import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/post/post.dart';

/// Result class for post list operations containing posts and pagination cursors.
class PostListResult {
  /// List of instantiated Post objects
  final List<Post> posts;

  /// Cursor for the next page of results, null if no next page
  final String? nextCursor;

  /// Cursor for the previous page of results, null if no previous page
  final String? prevCursor;

  PostListResult({
    required this.posts,
    this.nextCursor,
    this.prevCursor,
  });
}

/// This class defines a series of actions that can be performed on a post.
class PostHelper {
  final FediverseClient _client;

  PostHelper(this._client);

  Future<Post> call({int? id, Map<String, dynamic>? post}) => Post.initialize(_client, id: id, post: post);

  /// Resolves a given post report.
  /// TODO: Fix return type - it returns a post report instead of a post
  // Future<Post> resolve({required int reportId}) async {
  //   final endpoint = '/post/report/resolve';

  //   final result = await _client.sendPutRequest(
  //     path: endpoint,
  //     body: {
  //       'report_id': reportId,
  //       'resolved': true,
  //     },
  //   );

  //   if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

  //   final response = jsonDecode(result.body);
  //   return Post.initialize(_client, id: id, post: response);
  // }

  /// Unresolves a given post report.
  /// TODO: Fix return type - it returns a post report instead of a post
  // Future<Post> unresolve({required int reportId}) async {
  //   final endpoint = '/post/report/resolve';

  //   final result = await _client.sendPutRequest(
  //     path: endpoint,
  //     body: {
  //       'report_id': reportId,
  //       'resolved': false,
  //     },
  //   );

  //   if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

  //   final response = jsonDecode(result.body);
  //   return Post.initialize(_client, id: id, post: response);
  // }
}
