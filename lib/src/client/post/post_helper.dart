import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

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
///
/// // When the post is created, you can interact with it.
/// post.upvote();
/// ```
class PostHelper {
  final LemmyClient _client;

  PostHelper(this._client);

  Post call({required int id}) => Post(_client, id: id);

  /// Creates a new post. This is only available for authenticated users.
  ///
  /// TODO: Add support for tags.
  /// TODO: Add support for scheduling posts.
  Future<Post> create({
    required String title,
    required int communityId,
    String? url,
    String? body,
    String? altText,
    bool? nsfw,
    int? languageId,
    String? thumbnailUrl,
  }) async {
    if (_client.auth == null) throw Exception('You must be authenticated to create a post.');

    if (url == null && altText != null) throw Exception('You must provide a URL when providing alt text.');
    if (url == null && thumbnailUrl != null) throw Exception('You must provide a URL when providing a custom thumbnail.');

    final v4Endpoint = '/post';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.sendPostRequest(
      path: path,
      body: {
        'name': title,
        'community_id': communityId,
        'url': url,
        'body': body,
        'alt_text': altText,
        'nsfw': nsfw,
        'language_id': languageId,
        'custom_thumbnail': thumbnailUrl,
      },
    );

    return Post.populate(_client, id: result['id'], info: result);
  }
}
