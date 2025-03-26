import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import 'config.dart';

void main() {
  late LemmyClient client;

  setUpAll(() async {
    client = await LemmyClient.initialize(
      instance: instance,
      version: version,
      scheme: 'https',
    );
  });

  group('Browsing', () {
    test('should be able to mimic browsing on feed', () async {
      final feed = await client.feed(type: 'all').posts();
      expect(feed, isNotNull);
      expect(feed.containsKey('posts'), isTrue);
      expect(feed['posts'], isNotEmpty);

      final pv = feed['posts'].first;
      final postId = pv['post']['id'];

      final post = await client.post(id: postId).refresh();
      expect(post, isNotNull);
      expect(post.containsKey('id'), isTrue);
      expect(post['id'], postId);
    });
  });
}
