import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';

void main() {
  group('Post tests', () {
    late LemmyClient client;

    setUp(() async {
      client = await LemmyClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
    });

    group('info() method', () {
      test('should return the post information', () async {
        final post = client.post(id: '1');
        final result = await post.info();
        expect(result, contains('post_view'));
      });
    });

    group('comments() method', () {
      test('should return the comments for the post', () async {
        final post = client.post(id: '1');
        final result = await post.comments(sort: 'New', limit: 10);
        expect(result, contains('comments'));
      });
    });
  });
}
