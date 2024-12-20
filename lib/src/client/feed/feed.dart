import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';
import 'package:lemmy_dart_client/src/client/utils/post_sort.dart';

class Feed {
  final LemmyClient _client;

  /// The feed type to fetch.
  final String type;

  Feed(this._client, {required this.type}) {
    assert(type == 'local' || type == 'subscribed' || type == 'all' || type == 'moderator');
  }

  /// The feed type to fetch. This is internal as the types might change.
  String _getType() {
    if ((type == 'subscribed' || type == 'moderator') && _client.auth == null) {
      throw Exception('You must be authenticated to view the $type feed.');
    }

    return switch (type) {
      'all' => 'All',
      'local' => 'Local',
      'subscribed' => 'Subscribed',
      'moderator' => 'ModeratorView',
      _ => throw Exception('Invalid feed type'),
    };
  }

  /// Fetches posts from the given feed.
  ///
  /// Returns a map containing the list of posts, and the next cursor.
  Future<Map<String, dynamic>> posts({
    String? sort,
    String? topSort, // Top sort type (e.g., hour, six_hours, twelve_hours, day, week, month, three_months, six_months, nine_months, year, all)
    Duration? range, // Time range in seconds to show posts from (e.g., 3600 for the last hour)
    String? cursor,
    bool? hidden, // Overrides user settings and shows hidden posts
    bool? read, // Overrides user settings and shows read posts
    bool? nsfw, // Overrides user settings and shows NSFW posts
  }) async {
    if (_client.version == 'v3' && range != null) {
      // If v3, range is ignored.
      print('WARN: The [range] parameter is not supported in v3. Ignoring the parameter.');
    }

    final v4Endpoint = '/post/list';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.get(
      path: path,
      body: {
        'type_': _getType(),
        'sort': sort != null ? getSort(sort, _client.version) : null,
        'time_range_seconds': range?.inSeconds,
        'show_hidden': hidden,
        'show_read': read,
        'show_nsfw': nsfw,
        'page_cursor': cursor,
      },
    );

    return result;
  }
}
