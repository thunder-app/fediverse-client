import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/community/community.dart';

/// This class defines a series of actions that can be performed on a community.
class CommunityHelper {
  final LemmyClient _client;

  CommunityHelper(this._client);

  Future<Community> call({int? id, String? name}) => Community.initialize(_client, id: id, name: name);

  /// List communities available on the instance.
  Future<Map<String, dynamic>> list({
    String? type,
    String? sort,
    int? limit,
    bool? nsfw,
    String? cursor,
  }) async {
    final endpoint = '/community/list';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'type_': type,
      'sort': sort,
      'limit': limit,
      'show_nsfw': nsfw,
      'page_cursor': cursor,
    });

    return jsonDecode(result.body);
  }

  // /// Creates a new community.
  // Future<Map<String, dynamic>> create({
  //   required String name,
  //   required String title,
  //   String? description,
  //   String? sidebar,
  //   String? icon,
  //   String? banner,
  //   bool? nsfw,
  //   bool? restricted,
  //   List<int>? languages,
  //   String? visibility,
  // }) async {
  //   final endpoint = '/community';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'name': name,
  //     'title': title,
  //     'description': description,
  //     'sidebar': sidebar,
  //     'icon': icon,
  //     'banner': banner,
  //     'nsfw': nsfw,
  //     'posting_restricted_to_mods': restricted,
  //     'discussion_languages': languages,
  //     'visibility': visibility,
  //   });

  //   return jsonDecode(result.body);
  // }

  // /// Fetches a random community.
  // Future<Map<String, dynamic>> random() async {
  //   final endpoint = '/community/random';
  //   final result = await _client.sendGetRequest(path: endpoint);

  //   return jsonDecode(result.body);
  // }
}
