import 'dart:convert';

import 'package:lemmy_dart_client/src/client/client.dart';
import 'package:lemmy_dart_client/src/client/inbox/inbox_helper.dart';

/// This class defines a series of actions that can be performed on the current account.
///
/// Usage:
/// ```dart
/// final client = await LemmyClient.initialize({
///   instance: 'lemmy.world',
///   scheme: 'https',
/// });
///
/// // Initialize account helper and load account info if authenticated
/// await client.account.initialize();
///
/// // Login to the account
/// await client.account.login(username: 'username', password: 'password');
///
/// // Logout of the account
/// await client.account.logout();
///
/// // Validate the authentication token
/// await client.account.validateToken();
///
/// // Get the current account information
/// await client.account.info();
///
/// // Delete the account
/// await client.account.delete(password: 'password');
///
/// // Get the current account's posts
/// await client.account.posts();
///
/// // Get the current account's comments
/// await client.account.comments();
/// ```
class AccountHelper {
  final LemmyClient _client;

  AccountHelper(this._client);

  /// Initializes the account helper and loads account information if authentication is available.
  Future<void> initialize() async {
    if (_client.auth != null) {
      try {
        await info();
      } catch (e) {
        // If loading account info fails, clear the auth token as it might be invalid
        _client.auth = null;
      }
    }
  }

  /// The inbox helper.
  InboxHelper get inbox => InboxHelper(_client);

  /// The account information.
  Map<String, dynamic>? _account;

  /// Ensures that account information is loaded. If not, attempts to load it.
  /// Throws an exception if no authentication token is available.
  Future<void> _checkAccountInfo() async {
    if (_account == null) {
      if (_client.auth == null) {
        throw Exception('Authentication required. Please login first.');
      }
      await info();
    }
  }

  /// Registers a new account using email and password.
  ///
  /// The [password] should be already verified by the application.
  /// The [email] is optional unless the instance requires email verification.
  /// The [answer] is optional unless the instance requires an application.
  ///
  /// If a captcha is required, [captchaId] and [captchaAnswer] must be provided.
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    String? email,
    bool? nsfw,
    String? answer,
    String? captchaId,
    String? captchaAnswer,
  }) async {
    final endpoint = '/account/auth/register';

    final result = await _client.sendPostRequest(path: endpoint, body: {
      'username': username,
      'password': password,
      'password_verify': password,
      'email': email,
      'show_nsfw': nsfw,
      'answer': answer,
      'captcha_uuid': captchaId,
      'captcha_answer': captchaAnswer,
    });

    final body = jsonDecode(result.body);

    // If registration was successful and a JWT token was provided, set it and load account info.
    if (body['jwt'] != null) {
      _client.auth = body['jwt'];
      await info(); // Load account information after successful registration
    }

    return body;
  }

  /// Logs in to the account using username (or email) and password.
  ///
  /// If 2FA is enabled, you can provide the TOTP token to login.
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String? totp,
  }) async {
    final endpoint = '/account/auth/login';
    final result = await _client.sendPostRequest(path: endpoint, body: {
      'username_or_email': username,
      'password': password,
      'totp_2fa_token': totp,
    });

    final body = jsonDecode(result.body);

    // If the login was successful, set the authentication token and load account info.
    if (body['jwt'] != null) {
      _client.auth = body['jwt'];
      await info(); // Load account information after successful login
    }

    return body;
  }

  /// Logs out of the current account.
  Future<Map<String, dynamic>> logout() async {
    final endpoint = '/account/auth/logout';
    final result = await _client.sendPostRequest(path: endpoint);

    final body = jsonDecode(result.body);

    // If the logout was successful, clear the authentication token and account info.
    if (body['success'] == true) {
      _client.auth = null;
      _account = null; // Clear stored account information
    }

    return body;
  }

  /// Fetches the account's captcha for registration.
  Future<Map<String, dynamic>> captcha() async {
    final endpoint = '/account/auth/get_captcha';
    final result = await _client.sendGetRequest(path: endpoint);

    return jsonDecode(result.body);
  }

  /// Fetches the current account information.
  Future<Map<String, dynamic>> info() async {
    final endpoint = '/account';
    final result = await _client.sendGetRequest(path: endpoint);

    // Store the account information for later use.
    _account = jsonDecode(result.body);
    return _account!;
  }

  /// Validates the authentication token.
  Future<Map<String, dynamic>> validateToken() async {
    final endpoint = '/account/validate_auth';
    final result = await _client.sendGetRequest(path: endpoint);

    return jsonDecode(result.body);
  }

  /// Gets the current account's posts.
  Future<Map<String, dynamic>> posts({
    String? sort,
    int? limit,
    bool? saved,
    String? cursor,
  }) async {
    // Ensure account information is loaded
    await _checkAccountInfo();

    final accountId = _account?['local_user_view']['person']['id'];

    final endpoint = '/person/content';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'type_': "Posts",
      'person_id': accountId,
      'sort': sort,
      'limit': limit,
      'saved_only': saved,
      'page_cursor': cursor,
    });

    return jsonDecode(result.body);
  }

  /// Gets the current account's comments.
  Future<Map<String, dynamic>> comments({
    String? sort,
    int? limit,
    bool? saved,
    String? cursor,
  }) async {
    // Ensure account information is loaded
    await _checkAccountInfo();

    final accountId = _account?['local_user_view']['person']['id'];

    final endpoint = '/person/content';
    final result = await _client.sendGetRequest(path: endpoint, body: {
      'type_': "Comments",
      'person_id': accountId,
      'sort': sort,
      'limit': limit,
      'saved_only': saved,
      'page_cursor': cursor,
    });

    return jsonDecode(result.body);
  }

  // /// Deletes the current account.
  // Future<Map<String, dynamic>> delete({required String password}) async {
  //   final endpoint = '/account';
  //   final result = await _client.sendPostRequest(path: endpoint, body: {
  //     'password': password,
  //   });

  //   return jsonDecode(result.body);
  // }
}
