import 'package:lemmy_dart_client/src/client/community/community.dart';
import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

/// The [CommunityHelper] class is used to interact with communities on a Lemmy instance.
/// This class should only implement methods that are not specific to a single community.
///
/// To interact with a specific community, use the [Community] class.
///
/// Example:
/// ```dart
/// final client = await LemmyClient.initialize();
///
/// // Create a new community.
/// final community = client.community.create({
///   name: 'community',
///   title: 'Community',
///   sidebar: 'This is the sidebar of my new community',
///   description: 'This is the description of my new community',
///   icon: 'https://example.com/icon.png',
///   banner: 'https://example.com/banner.png',
///   nsfw: false,
///   locked: false,
///   languages: [1, 2, 3],
///   visibility: 'local',
/// });
/// ```
class CommunityHelper {
  /// The client instance.
  final LemmyClient _client;

  CommunityHelper(this._client);

  Community call({int? id, String? name}) => Community(_client, id: id, name: name);

  /// Fetches a list of communities given a set of filters.
  ///
  /// When [nsfw] is set to `true`, the method will include NSFW communities.
  Future<List<Community>> list({
    String? type,
    String? sort,
    bool? nsfw,
  }) async {
    assert(type == null || ['all', 'local', 'subscribed'].contains(type));

    final v4Endpoint = '/community/list';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.sendGetRequest(path: path, body: {
      'type': type?.replaceRange(0, 1, type[0].toUpperCase()),
      // 'sort': sort,
      'nsfw': nsfw,
    });

    if (result.containsKey('communities') == false) throw Exception('Failed to fetch communities.');
    return List<Community>.from(result['communities'].map((cv) => Community.populate(_client, id: cv['community']['id'], info: cv)));
  }

  /// Creates a new community. This is only available for authenticated users.
  Future<Community> create({
    required String name,
    required String title,
    String? sidebar,
    String? description,
    String? icon,
    String? banner,
    bool? nsfw,
    bool? locked,
    List<int>? languages,
    String? visibility,
  }) async {
    if (_client.auth == null) throw Exception('You must be authenticated to create a community.');

    final v4Endpoint = '/community';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.sendPostRequest(
      path: path,
      body: {
        'name': name,
        'title': title,
        'sidebar': sidebar,
        'description': description,
        'icon': icon,
        'banner': banner,
        'nsfw': nsfw,
        'posting_restricted_to_mods': locked,
        'discussion_languages': languages,
        'visibility': visibility,
      },
    );

    if (result.containsKey('community_view') == false) throw Exception('Failed to create community.');

    return Community.populate(_client, id: result['community_view']['community']['id'], info: result);
  }
}
