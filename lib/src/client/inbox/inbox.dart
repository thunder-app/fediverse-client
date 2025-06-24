import 'package:fediverse_client/src/client/client.dart';

/// This class defines a series of actions that can be performed on the current account's inbox.
///
/// Usage:
/// ```dart
/// final client = await FediverseClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
///
/// ```
class Inbox {
  /// The client instance.
  final FediverseClient _client;

  /// Initializes a new inbox.
  Inbox(this._client);
}
