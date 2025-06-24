import 'dart:convert';

import 'package:fediverse_client/src/client/client.dart';

/// This class defines a series of actions that can be performed on a given site.
///
/// Usage:
/// ```dart
/// final client = await FediverseClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch the site metadata
/// final metadata = await client.site(instance: 'https://lemmy.world').metadata();
/// ```
class Site {
  /// The client instance.
  final FediverseClient _client;

  /// The instance.
  final String instance;

  /// Initializes a new site with the given instance.
  Site(this._client, {required this.instance});

  /// Fetches the metadata of the given instance.
  Future<Map<String, dynamic>> metadata() async {
    final endpoint = '/post/site_metadata';
    final result = await _client.sendGetRequest(path: endpoint, body: {'url': instance});

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    return jsonDecode(result.body);
  }
}
