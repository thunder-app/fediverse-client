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

      expect(result.containsKey('posts'), isTrue);
      expect(result.containsKey('next_page'), isTrue);
      expect(result, isNotNull);
    });

    test('should properly fetch feed listings from local', () async {
      final result = await client.feed(type: 'local').posts();

      expect(result.containsKey('posts'), isTrue);
      expect(result.containsKey('next_page'), isTrue);
      expect(result, isNotNull);
    });

    test('should properly fetch next page of feed', () async {
      final feed = client.feed(type: 'local');

      final page1 = await feed.posts();
      expect(page1.containsKey('posts'), isTrue);
      expect(page1.containsKey('next_page'), isTrue);
      expect(page1, isNotNull);

      final cursor = page1['next_page'];
      final page2 = await feed.posts(cursor: page1['next_page']);
      expect(page2, isNotNull);
      expect(cursor, isNot(page2['next_page']));
    });

    test('should properly fetch feed listings with a given sort type', () async {
      final result = await client.feed(type: 'local').posts(sort: 'old');

      expect(result.containsKey('posts'), isTrue);
      expect(result.containsKey('next_page'), isTrue);
      expect(result, isNotNull);
    });

    test('should properly throw error when fetching feed listings from subscriptions without being logged in', () async {
      expect(() => client.feed(type: 'subscribed').posts(), throwsException);
    });

    test('should properly throw error when fetching feed listings from  moderator view without being logged in', () async {
      expect(() => client.feed(type: 'moderator').posts(), throwsException);
    });
  });
}
