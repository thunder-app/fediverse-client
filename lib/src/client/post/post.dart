import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

/// The [Post] class is used to interact with a given post.
/// This class should only implement methods that are specific to a single post.
///
/// Example:
/// ```dart
/// final client = await LemmyClient.initialize();
///
/// // Fetch a post with a given ID, and interact with it.
/// final post = client.post(id: 1).refresh();
/// post.upvote(); // Upvotes the post - when called on an already upvoted post, it will remove the upvote
/// post.save(); // Saves the post - when called on an already saved post, it will unsave the post
///
/// // You can create a new post by calling the create method. This returns a post that you can interact with.
/// final newPost = client.post.create();
/// newPost.vote();
/// ```
class Post {
  final LemmyClient _client;

  /// The post id.
  final int id;

  Post(this._client, {required this.id});

  Map<String, dynamic>? info;

  List<Map<String, dynamic>>? comments;

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

  /// Applies the given edit to the post. This will return a new post object that you can interact with.
  ///
  /// This action is only available if the post is created by the current user.
  Future<Map<String, dynamic>> edit() {
    throw Exception('Not implemented');
  }

  /// Deletes the post.
  ///
  /// This action is only available if the post is created by the current user.
  Future<Map<String, dynamic>> delete() {
    throw Exception('Not implemented');
  }

  /// Upvotes the post. If the post is already upvoted, it will remove the upvote.
  Future<Map<String, dynamic>> upvote() {
    throw Exception('Not implemented');
  }

  /// Downvotes the post. If the post is already downvoted, it will remove the downvote.
  Future<Map<String, dynamic>> downvote() {
    throw Exception('Not implemented');
  }

  /// Saves the post. If the post is already saved, it will unsave the post.
  Future<Map<String, dynamic>> save() {
    throw Exception('Not implemented');
  }

  /// Marks the post as read. If the post is already read, it will mark it as unread.
  Future<Map<String, dynamic>> read() {
    throw Exception('Not implemented');
  }

  /// Hides the post. If the post is already hidden, it will unhide the post.
  Future<Map<String, dynamic>> hide() {
    throw Exception('Not implemented');
  }

  /// Reports the post to the moderator/admin of the instance.
  Future<Map<String, dynamic>> report() {
    throw Exception('Not implemented');
  }

  /// Locks the post. If the post is already locked, it will unlock the post.
  ///
  /// This action is only available to moderators/admins.
  Future<Map<String, dynamic>> lock() {
    throw Exception('Not implemented');
  }

  /// Removes the post.
  ///
  /// This action is only available to moderators/admins.
  Future<Map<String, dynamic>> remove() {
    throw Exception('Not implemented');
  }

  /// Pins the post. If the post is already pinned, it will unpin the post.
  /// The [type] parameter can be used to specify the type of pinning. By default, it is set to 'community'.
  /// The available types are: ['community', 'instance'].
  ///
  /// This action is only available to moderators/admins.
  Future<Map<String, dynamic>> pin({String type = 'community'}) {
    throw Exception('Not implemented');
  }
}
