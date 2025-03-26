import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';

/// This defines a series of actions that can be performed on a given post.
///
/// The [PostHelper] class is used to interact with posts on a Lemmy instance.
///
/// Example:
/// ```dart
/// final client = await LemmyClient.initialize();
///
/// // Fetch a post with a given ID, and interact with it.
/// final post = client.post(id: 1).refresh();
/// post.vote(); // Upvotes the post - when called on an already upvoted post, it will remove the upvote
/// post.save(); // Saves the post - when called on an already saved post, it will unsave the post
///
/// // You can create a new post by calling the create method. This returns a post that you can interact with.
/// final newPost = client.post.create();
/// newPost.vote();
/// ```
class PostHelper {
  final LemmyClient _client;

  PostHelper(this._client);

  Post call({required int id}) => Post(_client, id: id);

  /// Creates a new post. This is only available for authenticated users.
  Future<Post> create() async {
    if (_client.auth == null) throw Exception('You must be authenticated to create a post.');
    throw Exception('Not implemented');
  }
}
