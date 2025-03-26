import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';

void main() {
  late LemmyClient client;

  setUpAll(() async {
    client = await LemmyClient.initialize(
      instance: instance,
      version: version,
      scheme: 'https',
    );
  });

  group('Post', () {
    test('should properly fetch post', () async {
      final result = await client.post(id: 1).refresh();

      expect(result, isNotNull);
    });
  });
}
