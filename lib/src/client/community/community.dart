import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';

/// This class defines a series of actions that can be performed on a given community.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Initialize the community and fetch the community information
/// final community = await Community.initialize(client, id: 1);
///
/// // Submit a new post to the community
/// final post = await community.submit(name: 'Test Post', url: 'https://example.com');
///
/// // Fetch the posts for the community
/// final posts = await community.posts(type: 'All', sort: 'Active', limit: 10);
///
///
/// ```
class Community {
  /// The client instance.
  final LemmyClient _client;

  /// The community id.
  final int? id;

  /// The community name. This can be in the format `community_name@instance.tld` or just `community_name`.
  final String? name;

  /// The internal community information. This should be updated whenever the community information changes.
  Map<String, dynamic>? _community;

  /// Private constructor for creating a Community instance.
  Community._(this._client, {this.id, this.name}) : assert((id == null) != (name == null), 'Exactly one of id or name must be provided');

  /// Initializes a new community with the given id or name and fetches its information.
  /// Either [id] or [name] must be provided, but not both.
  static Future<Community> initialize(LemmyClient client, {int? id, String? name}) async {
    final community = Community._(client, id: id, name: name);
    await community.info();
    return community;
  }

  /// Fetches the information of the given post.
  Future<Map<String, dynamic>> info() async {
    final endpoint = '/community';

    final result = await _client.sendGetRequest(path: endpoint, body: {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });

    // Store the community information for later use.
    _community = jsonDecode(result.body);
    return _community!;
  }

  /// Fetches the posts for the given community.
  ///
  /// A optional [sort] can be provided to sort the posts.
  /// A optional [cursor] can be provided to fetch the posts after the given cursor.
  /// A optional [limit] can be provided to limit the number of posts returned.
  Future<Map<String, dynamic>> posts({
    String? sort,
    String? cursor,
    int? limit,
  }) async {
    int? communityId = _community?['community_view']['community']['id'];

    final endpoint = '/post/list';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'community_id': communityId,
      if (sort != null) 'sort': sort,
      if (cursor != null) 'page_cursor': cursor,
      if (limit != null) 'limit': limit,
    });

    return jsonDecode(result.body);
  }

  // /// Edits the given community.
  // Future<Map<String, dynamic>> edit({
  //   String? title,
  //   String? description,
  //   String? sidebar,
  //   String? icon,
  //   String? banner,
  //   bool? nsfw,
  //   bool? restricted,
  //   List<int>? languages,
  //   String? visibility,
  // }) async {
  //   final communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/community';
  //   final result = await _client.sendPutRequest(path: endpoint, body: {
  //     'community_id': communityId,
  //     if (title != null) 'title': title,
  //     if (description != null) 'description': description,
  //     if (sidebar != null) 'sidebar': sidebar,
  //     if (icon != null) 'icon': icon,
  //     if (banner != null) 'banner': banner,
  //     if (nsfw != null) 'nsfw': nsfw,
  //     if (restricted != null) 'posting_restricted_to_mods': restricted,
  //     if (languages != null) 'discussion_languages': languages,
  //     if (visibility != null) 'visibility': visibility,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Deletes the given community.
  // Future<Map<String, dynamic>> delete({String? reason}) async {
  //   final communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/community/delete';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'community_id': communityId,
  //     'deleted': true,
  //     'reason': reason,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Restores the given community.
  // Future<Map<String, dynamic>> restore({String? reason}) async {
  //   final communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/community/delete';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'community_id': communityId,
  //     'deleted': false,
  //     'reason': reason,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Subscribes to the given community.
  // Future<Map<String, dynamic>> subscribe() async {
  //   final communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/community/follow';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'community_id': communityId,
  //     'follow': true,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Unsubscribes from the given community.
  // Future<Map<String, dynamic>> unsubscribe() async {
  //   final communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/community/follow';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'community_id': communityId,
  //     'follow': false,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Submits a new post to the given community.
  // Future<Map<String, dynamic>> submit({
  //   required String name,
  //   String? url,
  //   String? body,
  //   String? altText,
  //   bool? nsfw,
  //   int? languageId,
  //   String? thumbnailUrl,
  //   List<int>? tags,
  //   DateTime? scheduledAt,
  // }) async {
  //   int? communityId = _community?['community_view']['community']['id'];

  //   final endpoint = '/post';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'name': name,
  //     'community_id': communityId,
  //     if (url != null) 'url': url,
  //     if (body != null) 'body': body,
  //     if (altText != null) 'alt_text': body,
  //     if (nsfw != null) 'nsfw': nsfw,
  //     if (languageId != null) 'language_id': languageId,
  //     if (thumbnailUrl != null) 'custom_thumbnail': thumbnailUrl,
  //     if (tags != null) 'tags': tags,
  //     if (scheduledAt != null) 'scheduled_publish_time': scheduledAt.millisecondsSinceEpoch,
  //   });

  //   return jsonDecode(result.body);
  // }
}
