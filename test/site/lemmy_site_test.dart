import 'package:fediverse_client/src/client/post/post.dart';
import 'package:test/test.dart';

import 'package:fediverse_client/src/client/client.dart';

import '../config.lemmy.dart';
import '../utils.dart';

void main() {
  group('Site tests', () {
    late FediverseClient client;

    setUp(() async {
      client = await FediverseClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
      await client.account.login(username: username, password: password);
    });

    group('info() method', () {
      test('should return the site information', () async {
        final result = await client.site.info();
        expect(result, contains('site_view'));
      });
    });

    group('metadata() method', () {
      test('should exist and return the site metadata', () async {
        final result = await client.site.call(instance: 'https://lemmy.world').metadata();
        expect(result, contains('metadata'));
      });
    });

    group('pin() method', () {
      test('should return the pinned post', () async {
        // Create a post in a given community
        final community = await client.community(name: 'test_community');
        final post = await community.submit(name: 'Test Post ${generateRandomString(10)}', url: 'https://example.com', body: 'This is a test post');

        final result = await client.site.pin(postId: post.id!);
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['featured_local'], true);
      });
    });

    group('unpin() method', () {
      test('should return the unpinned post', () async {
        // Create a post in a given community
        final community = await client.community(name: 'test_community');
        final post = await community.submit(name: 'Test Post ${generateRandomString(10)}', url: 'https://example.com', body: 'This is a test post');

        await client.site.pin(postId: post.id!);

        final result = await client.site.unpin(postId: post.id!);
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['featured_local'], false);
      });
    });

    // group('federation() method', () {
    //   test('should return the federated instances', () async {
    //     final result = await client.site.federation();
    //     expect(result, contains('federated_instances'));
    //   });
    // });

    // // TODO: Implement create() method
    // group('create() method', () {
    //   test('should throw UnimplementedError', () async {
    //     expect(
    //       () async => await client.site.create(),
    //       throwsA(isA<UnimplementedError>()),
    //     );
    //   });
    // });

    // // TODO: Implement edit() method
    // group('edit() method', () {
    //   test('should throw UnimplementedError', () async {
    //     expect(
    //       () async => await client.site.edit(),
    //       throwsA(isA<UnimplementedError>()),
    //     );
    //   });
    // });
  });
}
