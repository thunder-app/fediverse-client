import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';

void main() {
  late LemmyClient client;

  setUpAll(() async {
    client = await LemmyClient.initialize(
      instance: instance,
      version: version,
      scheme: scheme,
    );
  });

  group('Post', () {
    test('should properly create a new post', () async {
      await client.account.login(username: username, password: password);

      final result = await client.post.create(
        title: 'Test Post',
        communityId: 1,
        body: 'This is a test post',
      );

      expect(result, isNotNull);
    });

    test('should properly fetch post', () async {
      final result = await client.post(id: 1).refresh();

      expect(result, isNotNull);
    });
  });
}
