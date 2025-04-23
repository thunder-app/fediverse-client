import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';
import '../utils/utils.dart';

void main() {
  late LemmyClient client;

  setUpAll(() async {
    client = await LemmyClient.initialize(
      instance: instance,
      version: version,
      scheme: scheme,
    );
  });

  group('Community', () {
    test('should properly fetch a list of communities', () async {
      final result = await client.community.list();
      expect(result, isNotNull);
    });

    test('should properly fetch a list of communities with nsfw enabled', () async {
      final result = await client.community.list(nsfw: true);
      expect(result, isNotNull);
    });

    test('should properly create a new community', () async {
      await client.account.login(username: username, password: password);

      final result = await client.community.create(
        name: generateRandomString(10),
        title: 'Community',
      );

      expect(result, isNotNull);
      expect(result.info, isNotNull);
    });
  });
}
