import 'package:lemmy_dart_client/src/client/client.dart';

class Community {
  final LemmyClient _client;

  /// The id of the community for the given instance.
  ///
  /// The id of one community may not be the same as the id of the same community on another instance.
  /// Therefore, it is recommended to use the name field with the instance instead of the id field.
  final int? id;

  /// The name of the community. For example: thunder, or thunder@xyz.tld
  ///
  /// If the instance is not provided, it will fetch the community from the current instance.
  final String? name;

  Community(this._client, {this.id, this.name});

  /// Fetches the details of a community with the given id or name.
  // Future<CommunityResponse> details() async {
  //   final result = await _client.get(
  //     path: '/community',
  //     body: {
  //       'id': id,
  //       'name': name,
  //     },
  //   );

  //   return CommunityResponse.fromJson(result);
  // }

  /// Fetches more posts from the given feed.
  ///
  /// When successful, the client's site information is also updated.
  // Future<Map<String, dynamic>> posts(
  //   String? sort,
  //   Duration? range, // Time range in seconds to show posts from (e.g., 3600 for the last hour)
  //   String? cursor,
  //   bool? read, // Shows read posts, overrides user settings
  //   bool? nsfw, // Shows NSFW posts, overrides user settings
  // ) async {
  //   final v4Endpoint = '/post/list';
  //   final result = await _client.get(path: getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version), body: {
  //     'type_': _getType(),
  //     'sort': sort != null ? getSort(sort) : null,
  //   });

  //   return result;
  // }
}
