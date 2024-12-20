import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/feed/feed.dart';

/// This defines a series of actions that can be performed on a given feed.
/// This includes fetching local, subscibed, moderator, and all feeds.
///
/// Usage:
/// ```dart
/// // Initialize the client
/// LemmyClient client = await LemmyClient.initialize();
///
/// // Fetch all feed
/// client.feed(type: 'all').posts();
///
/// // Fetch local feed
/// client.feed(type: 'local').posts();
///
/// // Fetch subscribed feed
/// client.feed(type: 'subscribed').posts();
/// client.feed(type: 'subscribed').posts(cursor: 'cursor');
/// ```
class FeedHelper {
  final LemmyClient _client;

  FeedHelper(this._client);

  Feed call({required String type}) => Feed(_client, type: type);
}
