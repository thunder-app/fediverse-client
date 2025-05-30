import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';

void main() {
  group('Community tests', () {
    late LemmyClient client;

    setUp(() async {
      client = await LemmyClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
    });

    group('posts() method', () {
      test('should return the posts for the community', () async {
        final community = await client.community(name: 'test_community');
        final result = await community.posts(sort: 'Active', limit: 10);
        expect(result, contains('posts'));
      });
    });

    group('info() method', () {
      test('should return the community information', () async {
        final community = await client.community(name: 'test_community');
        final result = await community.info();
        expect(result, contains('community_view'));
      });
    });

    group('list() method', () {
      test('should return the list of communities', () async {
        final result = await client.community.list();
        expect(result, contains('communities'));
      });
    });

    // group('create() method', () {
    //   test('should return the created community', () async {
    //     await client.account.login(username: username, password: password);

    //     final result = await client.community.create(
    //       name: 'test_community',
    //       title: 'Test Community',
    //       description: 'This is a test community',
    //       sidebar: 'This is a test sidebar',
    //       icon: 'https://placehold.co/600x400',
    //       banner: 'https://placehold.co/600x400',
    //       nsfw: true,
    //       restricted: true,
    //       languages: [1],
    //       visibility: 'Public',
    //     );

    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('edit() method', () {
    //   test('should return the edited community', () async {
    //     await client.account.login(username: username, password: password);

    //     final community = await client.community(name: 'test_community');
    //     final result = await community.edit(
    //       title: 'Test Community (Edited)',
    //       description: 'This is a test community',
    //       sidebar: 'This is a test sidebar',
    //       icon: 'https://placehold.co/600x400',
    //       banner: 'https://placehold.co/600x400',
    //       nsfw: true,
    //       restricted: true,
    //       languages: [1],
    //       visibility: 'Public',
    //     );

    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('delete() method', () {
    //   test('should return the deleted community', () async {
    //     await client.account.login(username: username, password: password);

    //     final community = await client.community(name: 'test_community');
    //     final result = await community.delete(reason: 'Test reason');
    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('restore() method', () {
    //   test('should return the restored community', () async {
    //     await client.account.login(username: username, password: password);

    //     final community = await client.community(name: 'test_community');
    //     final result = await community.restore(reason: 'Test reason');
    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('random() method', () {
    //   test('should return a random community', () async {
    //     final result = await client.community.random();
    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('subscribe() method', () {
    //   test('should return the subscribed community', () async {
    //     await client.account.login(username: username, password: password);

    //     final community = await client.community(name: 'test_community');
    //     final result = await community.subscribe();
    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('unsubscribe() method', () {
    //   test('should return the unsubscribed community', () async {
    //     final community = await client.community(name: 'test_community');
    //     final result = await community.unsubscribe();
    //     expect(result, contains('community_view'));
    //   });
    // });

    // group('submit() method', () {
    //   test('should return the submitted post', () async {
    //     await client.account.login(username: username, password: password);

    //     final community = await client.community(name: 'test_community');
    //     final result = await community.submit(name: 'Test Post', url: 'https://example.com');
    //     expect(result, contains('post_view'));
    //   });
    // });
  });
}
