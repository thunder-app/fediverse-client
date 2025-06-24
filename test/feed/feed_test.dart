import 'package:test/test.dart';

import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/post/post_helper.dart';

import '../config.lemmy.dart';

void main() {
  group('Feed tests', () {
    late FediverseClient client;

    setUp(() async {
      client = await FediverseClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
    });

    group('posts() method', () {
      test('should return the posts for the community', () async {
        final feed = client.feed(type: 'All');

        final result = await feed.posts(sort: 'Active', limit: 10);
        expect(result, isA<PostListResult>());
        expect(result.posts.length, 10);
      });
    });
  });
}
