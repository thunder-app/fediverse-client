import 'dart:convert';

import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/post/post.dart';
import 'package:fediverse_client/src/client/site/site.dart';

/// This class defines a series of actions that can be performed on the current site.
///
/// Usage:
/// ```dart
/// final client = await FediverseClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Fetch the site information
/// await client.site.info();
///
/// // Fetch the federated instances of the current site
/// await client.site.federation();
///
/// // Not implemented: Create a new site
/// await client.site.create();
///
/// // Not implemented: Edit the current site information
/// await client.site.edit();
///
/// // Not implemented: Upload an icon to the site
/// await client.site.icon.upload(imageFile);
///
/// // Not implemented: Delete the site banner
/// await client.site.banner.delete();
///
/// // Check the health of the image server
/// await client.site.imageHealth();
/// ```
class SiteHelper {
  final FediverseClient _client;

  SiteHelper(this._client);

  Site call({required String instance}) => Site(_client, instance: instance);

  /// Refreshes the site information.
  ///
  /// When successful, the client's site information is also updated.
  Future<Map<String, dynamic>> info() async {
    final endpoint = '/site';
    final result = await _client.sendGetRequest(path: endpoint);

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    return jsonDecode(result.body);
  }

  /// Pins the given post to the top of the instance.
  Future<Post> pin({required int postId}) async {
    final endpoint = '/post/feature';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': postId,
        'featured': true,
        'feature_type': 'Local',
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: postId, post: response);
  }

  /// Unpins the given post from the top of the instance.
  Future<Post> unpin({required int postId}) async {
    final endpoint = '/post/feature';

    final result = await _client.sendPostRequest(
      path: endpoint,
      body: {
        'post_id': postId,
        'featured': false,
        'feature_type': 'Local',
      },
    );

    if (result.statusCode != 200) throw Exception(jsonDecode(result.body)['error']);

    final response = jsonDecode(result.body);
    return Post.initialize(_client, id: postId, post: response);
  }

  // /// Fetches the federated instances of the current site.
  // Future<Map<String, dynamic>> federation() async {
  //   final endpoint = '/federated_instances';
  //   final result = await _client.sendGetRequest(path: endpoint);

  //   return jsonDecode(result.body);
  // }

  // /// Creates the new site.
  // ///
  // /// This is only available to admins of the site.
  // Future<Map<String, dynamic>> create() async {
  //   throw UnimplementedError();
  // }

  // /// Edits the current site information.
  // ///
  // /// This is only available to admins of the site.
  // Future<Map<String, dynamic>> edit() async {
  //   throw UnimplementedError();
  // }

  // // Media management
  // // MediaManager get icon;    // POST /site/icon, DELETE /site/icon
  // // MediaManager get banner;  // POST /site/banner, DELETE /site/banner

  // /// Checks the health of the image server.
  // Future<Map<String, dynamic>> imageHealth() async {
  //   final endpoint = '/image/health';
  //   final result = await _client.sendPostRequest(path: endpoint);

  //   return jsonDecode(result.body);
  // }
}
