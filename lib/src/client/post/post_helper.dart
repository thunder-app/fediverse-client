import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/post/post.dart';

/// This class defines a series of actions that can be performed on a post.
class PostHelper {
  final LemmyClient _client;

  PostHelper(this._client);

  Post call({required String id}) => Post(_client, id: id);
}
