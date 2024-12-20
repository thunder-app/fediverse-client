import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/site/site.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

/// This defines a series of actions that can be performed on a given site.
class SiteHelper {
  final LemmyClient _client;

  SiteHelper(this._client);

  Site call({required String instance}) => Site(_client);

  Map<String, dynamic>? info;

  /// Refreshes the site information.
  ///
  /// When successful, the client's site information is also updated.
  Future<Map<String, dynamic>> refresh() async {
    final v4Endpoint = '/site';
    final result = await _client.get(path: getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version));

    info = result;
    return result;
  }

  /// Creates the new site. This is only available to admins of the site.
  Future<Map<String, dynamic>> create() async {
    if (_client.auth == null) throw Exception('You must be authenticated to create the site.');
    throw Exception('Not implemented');
  }

  /// Edits the current site information. This is only available to admins of the site.
  Future<Map<String, dynamic>> edit() async {
    if (_client.auth == null) throw Exception('You must be authenticated to edit the site information.');
    throw Exception('Not implemented');
  }
}
