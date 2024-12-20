/// Given the original endpoint, the original version, and the target version, return the equivalent endpoint in the target version.
///
/// For example:
/// ```dart
/// final v4Endpoint = '/admin/leave';
/// final version = 'v4';
/// final targetVersion = 'v3';
///
/// final v3Endpoint = getEndpoint(endpoint: v4Endpoint, version: version, targetVersion: targetVersion);
/// print(v3Endpoint); // Output: '/user/leave_admin'
/// ```
String getEndpoint({required String endpoint, required String version, required String targetVersion}) {
  if (version == targetVersion) return endpoint;

  /// This map contains all the endpoints mapping from v4 -> v3. If there is no equivalent v3 endpoint, then it is unsupported in v3.
  /// This currently uses all the endpoints available in v4 as of commit: 4eda61b6fd2b62d83e22616c14f540e4f57427c2
  ///
  /// However, there are a few endpoints in v4 that merged multiple v3 endpoints into one.
  /// In these cases, there will be separate logic to handle that.
  Map<String, String> v4v3Endpoints = {
    '/site': '/site',
    '/admin/leave': '/user/leave_admin',
    '/account/auth/totp/generate': '/user/totp/generate',
    '/account': '', // Added in v4 - This was previous part of the /site response
    '/account/settings/export': '/user/export_settings',
    '/account/settings/import': '/user/import_settings',
    '/account/list_logins': '/user/list_logins',
    '/account/validate_auth': '/user/validate_auth',
    '/account/list_media': '/account/list_media',
    '/admin/list_all_media': '/admin/list_all_media',
    '/account/auth/totp/update': '/user/totp/update',
    '/modlog': '/modlog',
    '/search': '/search',
    '/resolve_object': '/resolve_object',
    '/community': '/community',
    '/community/list': '/community/list',
    '/community/follow': '/community/follow',
    '/community/pending_follows/count': '', // Added in v4 - There is no equivalent in v3
    '/community/pending_follows/list': '', // Added in v4 - There is no equivalent in v3
    '/community/pending_follows/approve': '', // Added in v4 - There is no equivalent in v3
    '/account/block/community': '/community/block',
    '/community/delete': '/community/delete',
    '/community/hide': '/community/hide',
    '/community/remove': '/community/remove',
    '/community/transfer': '/community/transfer',
    '/community/ban_user': '/community/ban_user',
    '/community/mod': '/community/mod',
    '/community/random': '', // Added in v4 - This was previous part of the /site response
    '/post': '/post',
    '/post/delete': '/post/delete',
    '/post/remove': '/post/remove',
    '/post/mark_as_read': '/post/mark_as_read',
    '/post/mark_as_read/many': '', // Added in v4 - in v3, The endpoint `/post/mark_as_read` accepted an array of post ids
    '/post/hide': '/post/hide',
    '/post/lock': '/post/lock',
    '/post/feature': '/post/feature',
    '/post/list': '/post/list',
    '/post/like': '/post/like',
    '/post/like/list': '/post/like/list',
    '/post/save': '/post/save',
    '/post/report': '/post/report',
    '/post/report/resolve': '/post/report/resolve',
    '/post/site_metadata': '/post/site_metadata',
    '/comment': '/comment',
    '/comment/delete': '/comment/delete',
    '/comment/remove': '/comment/remove',
    '/comment/mark_as_read': '/comment/mark_as_read',
    '/comment/like': '/comment/like',
    '/comment/like/list': '/comment/like/list',
    '/comment/save': '/comment/save',
    '/comment/distinguish': '/comment/distinguish',
    '/comment/list': '/comment/list',
    '/comment/list/slim': '', // Added in v4 - There is no equivalent in v3
    '/comment/report': '/comment/report',
    '/comment/report/resolve': '/comment/report/resolve',
    '/private_message': '/private_message',
    '/private_message/delete': '/private_message/delete',
    '/private_message/mark_as_read': '/private_message/mark_as_read',
    '/private_message/report': '/private_message/report',
    '/private_message/report/resolve': '/private_message/report/resolve',
    '/account/auth/register': '/user/register',
    '/account/auth/login': '/user/login',
    '/account/auth/logout': '/user/logout',
    '/person': '/user',
    '/person/content': '/user', // Added in v4 - shows a given user's posts/comments
    '/account/mention/comment/mark_as_read': '/user/mention/mark_as_read',
    '/account/mention/post/mark_as_read': '/user/mention/mark_as_read',
    '/admin/ban': '/user/ban',
    '/admin/banned': '/user/banned',
    '/account/block/person': '/user/block',
    '/account/auth/get_captcha': '/user/get_captcha',
    '/account/delete': '/user/delete_account',
    '/account/auth/password_reset': '/user/password_reset',
    '/account/auth/password_change': '/user/password_change',
    '/account/mark_as_read/all': '/user/mark_all_as_read',
    '/account/settings/save': '/user/save_user_settings',
    '/account/auth/change_password': '/user/change_password',
    '/account/report_count': '/user/report_count',
    '/account/unread_count': '/user/unread_count',
    '/account/inbox': '', //  Added in v4. In v3, this was split up to separate endpoints
    '/account/auth/verify_email': '/user/verify_email',
    '/account/auth/resend_verification_email': '', // Added in v4 - There is no equivalent in v3
    '/account/auth/saved': '', // Added in v4 - In v3, this was part of the /post and /comment endpoints
    '/admin/add': '/admin/add',
    '/admin/registration_application/count': '/admin/registration_application/count',
    '/admin/registration_application/list': '/admin/registration_application/list',
    '/admin/registration_application/approve': '/admin/registration_application/approve',
    '/admin/registration_application': '/admin/registration_application',
    '/admin/purge/person': '/admin/purge/person',
    '/admin/purge/community': '/admin/purge/community',
    '/admin/purge/post': '/admin/purge/post',
    '/admin/purge/comment': '/admin/purge/comment',
    '/custom_emoji': '/custom_emoji',
    '/custom_emoji/delete': '/custom_emoji/delete',
    '/custom_emoji/list': '', // Added in v4 - There is no equivalent in v3
    '/admin/tagline': '', // Added in v4 - This was previously part of /site response
    '/admin/tagline/delete': '', // Added in v4 - This was previously part of /site response
    '/admin/tagline/list': '', // Added in v4 - This was previously part of /site response
    '/federated_instances': '/federated_instances',
    '/report/list': '', //  Added in v4. In v3, this was split up to separate endpoints
    '/account/block/instance': '/site/block',
    '/oauth_provider': '', // Added in v4 - There is no equivalent in v3
    '/oauth_provider/delete': '', // Added in v4 - There is no equivalent in v3
    '/oauth/authenticate': '', // Added in v4 - There is no equivalent in v3
    '/admin/instance/block': '', // Added in v4 - There is no equivalent in v3
    '/admin/instance/allow': '', // Added in v4 - There is no equivalent in v3
    '/account/avatar': '', // Added in v4 - There is no equivalent in v3
    '/account/banner': '', // Added in v4 - There is no equivalent in v3
    '/community/icon': '', // Added in v4 - There is no equivalent in v3
    '/community/banner': '', // Added in v4 - There is no equivalent in v3
    '/site/icon': '', // Added in v4 - There is no equivalent in v3
    '/site/banner': '', // Added in v4 - There is no equivalent in v3
    '/image': '', // Added in v4 - There is no equivalent in v3
    '/image/health': '', // Added in v4 - There is no equivalent in v3
  };

  // Converting a v4 endpoint to a v3 endpoint
  if (version == 'v4' && targetVersion == 'v3') {
    if (v4v3Endpoints.containsKey(endpoint)) {
      return v4v3Endpoints[endpoint]!;
    }
  }

  // Converting a v3 endpoint to a v4 endpoint
  if (version == 'v3' && targetVersion == 'v4') {
    for (final key in v4v3Endpoints.keys) {
      if (v4v3Endpoints[key] == endpoint) return key;
    }
  }

  throw Exception('Unable to determine target endpoint for $endpoint | version: $version -> $targetVersion');
}
