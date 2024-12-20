import 'package:lemmy_dart_client/lemmy_dart_client.dart';
import 'package:lemmy_dart_client/src/client/utils/endpoints.dart';

/// This defines a series of actions that can be performed on an account.
///
/// This includes account authentication, registration, deletion, and fetching account details.
///
/// Usage:
/// ```dart
/// // Initialize the client
/// final client = await LemmyClient.initialize();
///
/// // Access account information
/// client.account.info;
///
/// // Refresh account details
/// client.account.refresh();
///
/// // Login
/// client.account.login(username: 'user', password: 'password');
/// client.account.login(username: 'example@example.com', password: 'password');
///
/// // List logins
/// client.account.logins();
///
/// // Logout
/// client.account.logout();
///
/// // Fetch account posts
/// client.account.posts();
/// client.account.posts(page: 2, limit: 20); // For [v3] instances, the [page], and [limit] parameters are used to paginate the results.
/// client.account.posts(cursor: 'cursor'); // For [v4] instances, the [cursor] parameter is used to paginate the results.
/// client.account.posts(saved: true);
///
/// // Fetch account comments
/// client.account.comments();
/// client.account.comments(page: 2, limit: 20); // For [v3] instances, the [page], and [limit] parameters are used to paginate the results.
/// client.account.comments(cursor: 'cursor'); // For [v4] instances, the [cursor] parameter is used to paginate the results.
/// client.account.comments(saved: true);
///
/// TODO: Implement the following methods:
///
/// // Fetch accoount uploads
/// client.account.media();
///
/// // Fetch account subscriptions
/// client.account.subscriptions();
///
/// // Fetch account notifications
/// client.account.notifications.unread;
/// client.account.notifications.mentions();
/// client.account.notifications.messages();
/// client.account.notifications.replies();
///
/// // Import and export account settings
/// client.account.settings.import();
/// client.account.settings.export();
/// ```
class AccountHelper {
  final LemmyClient _client;

  /// The current account information.
  /// This should be dynamically updated when the account information is refreshed or when the instance is changed.
  Map<String, dynamic>? info;

  AccountHelper(this._client);

  /// Refreshes the current account's information.
  /// This generally should return information from a [MyUserInfo] object in the form of a Map.
  Future<Map<String, dynamic>?> refresh() async {
    // If the client is not authenticated, we cannot fetch account information.
    if (_client.auth == null) {
      info = null;
      throw Exception('You must be authenticated to fetch account information.');
    }

    if (_client.version == 'v4') {
      final result = await _client.get(path: '/account');
      info = result;
      return info;
    }

    // If we are on v3, we need to fetch the user info from the site.
    if (_client.version == 'v3') {
      await _client.site.refresh();

      if (_client.site.info?.containsKey('my_user') == true) {
        info = _client.site.info!['my_user'];
        return info;
      }
    }

    // If we are unable to fetch the account information, throw an exception.
    throw Exception('Unable to fetch account information');
  }

  /// Logs in the user with the given username/email and password.
  /// If the user has 2FA enabled, the token parameter is required.
  ///
  /// When the login is successful, the client's [auth] token is updated, and future requests
  /// will be automatically authenticated using the new [auth] token.
  Future<Map<String, dynamic>> login({required String username, required String password, String? token}) async {
    info = null; // Reset the account information

    final v4Endpoint = '/account/auth/login';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.post(
      path: path,
      body: {
        'username_or_email': username,
        'password': password,
        'totp_2fa_token': token,
      },
    );

    if (result.containsKey('jwt')) {
      _client.auth = result['jwt'];
      await refresh();
    }

    return result;
  }

  /// Lists all the logins for the current authenticated user.
  /// This includes the IP address, user agent, and the time of the login.
  Future<dynamic> logins() async {
    // If the client is not authenticated, we cannot perform action.
    if (_client.auth == null) {
      info = null;
      throw Exception('You must be authenticated to list logins.');
    }

    final v4Endpoint = '/account/list_logins';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.get(path: path);
    return result;
  }

  /// Logs out the current authenticated user.
  ///
  /// If the logout is successful, the client's [auth] token is set to null.
  Future<Map<String, dynamic>> logout() async {
    // If the client is not authenticated, we cannot logout.
    if (_client.auth == null) {
      info = null;
      throw Exception('You must be authenticated to logout.');
    }

    final v4Endpoint = '/account/auth/logout';
    final path = getEndpoint(endpoint: v4Endpoint, version: 'v4', targetVersion: _client.version);

    final result = await _client.post(path: path);

    if (result.containsKey('success') && result['success'] == true) {
      _client.auth = null;
      info = null;
    }

    return result;
  }

  /// Fetches the current account's posts.
  /// TODO: Implement sorting for v4 once it is available.
  /// TODO: Implement the following filters: read, upvoted, downvoted (from /post/list)
  ///
  /// There are some differences when calling this method depending on the server's version:
  /// - In v3, the [page] and [limit] parameters are used to paginate the results whereas in v4, the [cursor] parameter is used.
  /// - In v3, the [sort] parameter is used to sort the results whereas in v4, sorting is not available.
  Future<Map<String, dynamic>> posts({
    String? sort,
    int? page,
    int? limit,
    String? cursor,
    bool? saved,
  }) async {
    // If the client is not authenticated, we cannot get the account's posts.
    if (_client.auth == null) {
      info = null;
      throw Exception('You must be authenticated to fetch account posts.');
    }

    // Ensure that the account information is available before fetching posts.
    if (info == null) {
      throw Exception('Account information is not available');
    }

    // Perform basic validation of parameters depending on the current version.
    if (_client.version == 'v4') {
      if (sort != null) {
        print('WARN: The [sort] parameter is not supported in v4. Ignoring the parameter.');
      }

      if (page != null || limit != null) {
        print('WARN: The [page] and [limit] parameters are not supported in v4. Use [cursor] instead. Ignoring the parameter.');
      }
    } else if (_client.version == 'v3') {
      if (cursor != null) {
        print('WARN: The [cursor] parameter is not supported in v3. Use [page] and [limit] instead. Ignoring the parameter.');
      }
    }

    final id = info!['local_user_view']['person']['id'];

    switch (_client.version) {
      case 'v3':
        // In v3, we use the endpoint /user [GetPersonDetails] to get a given user's posts
        final path = '/user';

        final result = await _client.get(
          path: path,
          body: {
            'person_id': id,
            'sort': sort,
            'page': page,
            'limit': limit,
            'saved_only': saved,
          },
        );

        // We have to wrap this in a map since we need to return back the cursor for the v4 endpoint
        return {'posts': result['posts']};
      case 'v4':
        // In v4, we use the endpoint /person/content [ListPersonContent] to get a given user's posts
        // If the saved parameter is specified, we need to use a different endpoint /account/auth/saved [ListPersonSaved]
        String path = '/person/content';
        if (saved == true) path = '/account/auth/saved';

        final result = await _client.get(
          path: path,
          body: {
            'type': 'Posts', // We only want posts for this method
            'person_id': saved == true ? null : id, // If saved is true, we don't need to specify the person_id
            'page_cursor': cursor,
          },
        );

        return result;
      default:
        throw Exception('Unsupported version');
    }
  }

  /// Fetches the current account's comments.
  /// TODO: Implement sorting for v4 once it is available.
  ///
  /// There are some differences when calling this method depending on the server's version:
  /// - In v3, the [page] and [limit] parameters are used to paginate the results whereas in v4, the [cursor] parameter is used.
  /// - In v3, the [sort] parameter is used to sort the results whereas in v4, sorting is not available.
  Future<Map<String, dynamic>> comments({
    String? sort,
    int? page,
    int? limit,
    String? cursor,
    bool? saved,
  }) async {
    // If the client is not authenticated, we cannot get the account's comments.
    if (_client.auth == null) {
      info = null;
      throw Exception('You must be authenticated to fetch account comments.');
    }

    // Ensure that the account information is available before fetching comments.
    if (info == null) {
      throw Exception('Account information is not available');
    }

    // Perform basic validation of parameters depending on the current version.
    if (_client.version == 'v4') {
      if (sort != null) {
        print('WARN: The [sort] parameter is not supported in v4. Ignoring the parameter.');
      }

      if (page != null || limit != null) {
        print('WARN: The [page] and [limit] parameters are not supported in v4. Use [cursor] instead. Ignoring the parameter.');
      }
    } else if (_client.version == 'v3') {
      if (cursor != null) {
        print('WARN: The [cursor] parameter is not supported in v3. Use [page] and [limit] instead. Ignoring the parameter.');
      }
    }

    final id = info!['local_user_view']['person']['id'];

    switch (_client.version) {
      case 'v3':
        // In v3, we use the endpoint /user [GetPersonDetails] to get a given user's comments
        final path = '/user';

        final result = await _client.get(
          path: path,
          body: {
            'person_id': id,
            'sort': sort,
            'page': page,
            'limit': limit,
            'saved_only': saved,
          },
        );

        // We have to wrap this in a map since we need to return back the cursor for the v4 endpoint
        return {'comments': result['comments']};
      case 'v4':
        // In v4, we use the endpoint /person/content [ListPersonContent] to get a given user's comments
        // If the saved parameter is specified, we need to use a different endpoint /account/auth/saved [ListPersonSaved]
        String path = '/person/content';
        if (saved == true) path = '/account/auth/saved';

        final result = await _client.get(
          path: path,
          body: {
            'type': 'Comments', // We only want comments for this method
            'person_id': saved == true ? null : id, // If saved is true, we don't need to specify the person_id
            'page_cursor': cursor,
          },
        );

        return result;
      default:
        throw Exception('Unsupported version');
    }
  }
}
