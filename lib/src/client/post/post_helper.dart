import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';

/// The [PostHelper] class is used to interact with posts on a Lemmy instance.
/// This class should only implement methods that are not specific to a single post.
///
/// To interact with a specific post, use the [Post] class.
///
/// Example:
/// ```dart
/// final client = await LemmyClient.initialize();
///
/// // Create a new post.
/// final post = client.post.create({
///   communityId: 1,
///   title: 'Post Title',
///   body: 'This is the body of my new post',
///   url: 'https://example.com',
///   nsfw: false,
/// });
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
