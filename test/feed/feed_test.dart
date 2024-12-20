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

  group('Feed', () {
    test('should properly fetch feed listings from all', () async {
      final result = await client.feed(type: 'all').posts();
      expect(result, isNotNull);
    });

    test('should properly fetch feed listings from local', () async {
      final result = await client.feed(type: 'local').posts();
      expect(result, isNotNull);
    });

    test('should properly fetch next page of feed', () async {
      final feed = client.feed(type: 'local');

      Map<String, dynamic> result = await feed.posts();
      expect(result, isNotNull);

      final cursor = result['next_page'];
      result = await feed.posts(cursor: result['next_page']);
      expect(result, isNotNull);
      expect(cursor, isNot(result['next_page']));
    });

    test('should properly throw error when fetching feed listings from subscriptions without being logged in', () async {
      expect(() => client.feed(type: 'subscribed').posts(), throwsException);
    });

    test('should properly throw error when fetching feed listings from  moderator view without being logged in', () async {
      expect(() => client.feed(type: 'moderator').posts(), throwsException);
    });
  });
}
