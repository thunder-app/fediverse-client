import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/comment/comment.dart';

/// This class defines a series of actions that can be performed on a comment.
class CommentHelper {
  final LemmyClient _client;

  CommentHelper(this._client);

  Comment call({required String id}) => Comment(_client, id: id);
}
