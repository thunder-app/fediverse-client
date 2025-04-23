import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lemmy_dart_client/src/client/account/account_helper.dart';
import 'package:lemmy_dart_client/src/client/community/community_helper.dart';
import 'package:lemmy_dart_client/src/client/feed/feed_helper.dart';
import 'package:lemmy_dart_client/src/client/post/post_helper.dart';
import 'package:lemmy_dart_client/src/client/site/site_helper.dart';
import 'package:lemmy_dart_client/src/client/user/user_helper.dart';

/// A client that interacts with a Lemmy instance. The client must be initialized before it can be used.
/// When performing a request, the client will return a Map of the JSON response.
///
/// Example:
/// ```dart
/// final client = LemmyClient();
/// await client.initialize();
///
/// final siteInformation = client.site.info;
/// ```
class LemmyClient {
  /// The HTTP client to use when interacting with the Lemmy instance.
  final http.Client httpClient = http.Client();

  /// The URL of the Lemmy instance, excluding the scheme.
  /// For example, 'lemmy.world' or 'lemmy.ml'.
  late String host;

  /// The version of the Lemmy API to use. Defaults to 'v4'.
  /// Available versions are 'v3' and 'v4'.
  final String version;

  /// The scheme to use when interacting with the Lemmy instance. Defaults to 'https'.
  /// Should be one of 'http' or 'https'.
  final String scheme;

  /// The port to use when interacting with the Lemmy instance.
  /// Should only be used during development.
  late int? port;

  /// The authentication token for the current client instance.
  /// This is used to authenticate requests to the Lemmy instance as a given user.
  String? auth;

  /// Interface to work with [SiteHelper] instances.
  /// This is used to interact with the site information of the a Lemmy instance.
  late final SiteHelper site;

  /// Interface to work with [AccountHelper] instances.
  /// This is used to interact with the account information of the current user.
  late final AccountHelper account;

  /// Interface to work with [UserHelper] instances.
  // late final UserHelper user;

  /// Interface to work with [CommunityHelper] instances.
  late final CommunityHelper community;

  /// Interface to work with the [PostHelper] instances.
  late final PostHelper post;

  /// Interface to work with [FeedHelper] instances.
  late final FeedHelper feed;

  LemmyClient._({
    required this.host,
    required this.scheme,
    required this.version,
    this.auth,
  }) {
    // Set the port if the host string contains a port.
    final parts = host.split(':');

    if (scheme == 'http' && parts.length == 2) {
      host = parts[0];
      port = int.parse(parts[1]);
    } else {
      port = null;
    }

    site = SiteHelper(this);
    account = AccountHelper(this);
    feed = FeedHelper(this);
    post = PostHelper(this);
    // user = UserHelper(this);
    community = CommunityHelper(this);
  }

  /// Initializes the client with the given parameters.
  ///
  /// When the client is initialized, we also fetch the instance's site information.
  /// If the [auth] parameter is passed in, we also fetch the account information.
  static Future<LemmyClient> initialize({
    String instance = 'lemmy.thunderapp.dev',
    String scheme = 'https',
    String version = 'v3',
    String? auth,
  }) async {
    // Perform some basic assertions to ensure the parameters are valid.
    assert(instance.isNotEmpty && !instance.contains('http'));
    assert(version == 'v3' || version == 'v4');
    assert(scheme == 'http' || scheme == 'https');

    final client = LemmyClient._(
      host: instance,
      scheme: scheme,
      version: version,
      auth: auth,
    );

    await client.site.refresh();
    if (auth != null) await client.account.refresh();

    return client;
  }

  /// Helper method to perform GET requests.
  Future<Map<String, dynamic>> sendGetRequest({String? path, Map<String, dynamic>? body}) async {
    body?.removeWhere((key, value) => value == null);

    Map<String, String>? queryParameters;

    if (body != null) {
      queryParameters = <String, String>{};

      for (final entry in body.entries) {
        queryParameters[entry.key] = entry.value.toString();
      }
    }

    final response = await httpClient.get(
      Uri(
        scheme: scheme,
        host: host,
        port: port,
        path: 'api/$version$path',
        queryParameters: queryParameters,
      ),
      headers: {'Authorization': 'Bearer $auth'},
    );

    return _responseHandler(response);
  }

  /// Helper method to perform POST requests.
  Future<Map<String, dynamic>> sendPostRequest({String? path, Map<String, dynamic>? body}) async {
    body?.removeWhere((key, value) => value == null);

    final response = await httpClient.post(
      Uri(scheme: scheme, host: host, port: port, path: 'api/$version$path'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $auth'},
      body: jsonEncode(body),
    );

    return _responseHandler(response);
  }

  /// Helper method that handles the response from a given request.
  /// Converts the response body to a Map and throws an exception if the response is not successful.
  Map<String, dynamic> _responseHandler(http.Response response) {
    if (response.statusCode != 200) {
      var error = 'Unknown error';

      try {
        final json = jsonDecode(response.body);
        error = json['error'];
      } on FormatException {
        error = response.body;
      }

      throw Exception(error);
    }

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result is List) return {'data': result};
    return result;
  }
}
