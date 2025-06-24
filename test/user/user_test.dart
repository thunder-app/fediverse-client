import 'package:fediverse_client/src/client/comment/comment_helper.dart';
import 'package:fediverse_client/src/client/post/post_helper.dart';
import 'package:test/test.dart';

import 'package:fediverse_client/src/client/client.dart';

import '../config.lemmy.dart';

void main() {
  group('User tests', () {
    late FediverseClient client;

    setUp(() async {
      client = await FediverseClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
    });

    group('info() method', () {
      test('should return the user information', () async {
        final user = await client.user(id: 2);
        final result = await user.info();
        expect(result, contains('person_view'));
      });
    });

    group('posts() method', () {
      test('should return the posts for the user', () async {
        final user = await client.user(id: 2);
        final result = await user.posts(sort: 'Active', limit: 10);
        expect(result, isA<PostListResult>());
        expect(result.posts.length, 10);
      });
    });

    group('comments() method', () {
      test('should return the comments for the user', () async {
        final user = await client.user(id: 2);
        final result = await user.comments(sort: 'Active', limit: 10);
        expect(result, isA<CommentListResult>());
        expect(result.comments.length, 10);
      });
    });
  });
}
