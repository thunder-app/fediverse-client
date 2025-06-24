import 'package:fediverse_client/src/client/post/post.dart';
import 'package:test/test.dart';

import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/comment/comment.dart';
import 'package:fediverse_client/src/client/comment/comment_helper.dart';

import '../config.lemmy.dart';
import '../utils.dart';

void main() {
  group('Post tests', () {
    late FediverseClient client;

    int? postId;

    setUp(() async {
      client = await FediverseClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
      await client.account.login(username: username, password: password);

      // Fetch a random community
      final communities = await client.community.list();
      final community = communities.communities.first;

      // Submit a post to the community
      final post = await community.submit(name: 'Test Post', url: 'https://example.com', body: 'This is a test post');
      postId = post.id;
    });

    group('info() method', () {
      test('should return the post information', () async {
        final post = await client.post(id: postId!);
        final result = await post.info();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['post_view']['post']['name'], 'Test Post');
      });
    });

    group('edit() method', () {
      test('should return the edited post', () async {
        final post = await client.post(id: postId!);

        final editName = generateRandomString(10);
        final result = await post.edit(name: editName);

        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['name'], editName);
      });
    });

    group('reply() method', () {
      test('should return the reply', () async {
        final post = await client.post(id: postId!);

        final content = generateRandomString(10);
        final result = await post.reply(content: content);

        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['content'], content);
      });
    });

    group('comments() method', () {
      test('should return the comments for the post', () async {
        final post = await client.post(id: postId!);

        // Create 10 comments
        for (int i = 0; i < 10; i++) {
          await post.reply(content: 'This is a test comment $i');
        }

        final result = await post.comments(sort: 'New', limit: 10);
        expect(result, isA<CommentListResult>());
        expect(result.comments.length, 10);
      });
    });

    group('delete() method', () {
      test('should return the deleted post', () async {
        final post = await client.post(id: postId!);

        final result = await post.delete();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['deleted'], true);
      });
    });

    group('restore() method', () {
      test('should return the restored post', () async {
        final post = await client.post(id: postId!);

        await post.delete();
        final result = await post.restore();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['deleted'], false);
      });
    });

    group('remove() method', () {
      test('should return the removed post', () async {
        final post = await client.post(id: postId!);
        final result = await post.remove(reason: 'Test reason');
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['removed'], true);
      });
    });

    group('recover() method', () {
      test('should return the recovered post', () async {
        final post = await client.post(id: postId!);
        await post.remove(reason: 'Test reason');

        final result = await post.recover(reason: 'Test reason');
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['removed'], false);
      });
    });

    group('vote() method', () {
      test('should return the voted post', () async {
        final post = await client.post(id: postId!);
        final result = await post.vote(score: 1);
        expect(result, isA<Post>());

        Map<String, dynamic> info = await result.info();
        expect(info['post_view']['post']['score'], 1);

        // Vote again with a different score
        final result2 = await post.vote(score: -1);
        expect(result2, isA<Post>());

        info = await result2.info();
        expect(info['post_view']['post']['score'], -1);
      });
    });

    group('save() method', () {
      test('should return the saved post', () async {
        final post = await client.post(id: postId!);
        final result = await post.save();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['saved'], isNot(null));
      });

      test('should return the unsaved post', () async {
        final post = await client.post(id: postId!);
        await post.save();

        final result = await post.unsave();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['saved'], null);
      });
    });

    group('read() method', () {
      test('should return the read post', () async {
        final post = await client.post(id: postId!);
        final result = await post.read();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['read'], isNot(null));
      });

      test('should return the unread post', () async {
        final post = await client.post(id: postId!);
        await post.read();

        final result = await post.unread();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['read'], null);
      });
    });

    group('hide() method', () {
      test('should return the hidden post', () async {
        final post = await client.post(id: postId!);
        final result = await post.hide();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['hidden'], isNot(null));
      });

      test('should return the unhidden post', () async {
        final post = await client.post(id: postId!);
        await post.hide();

        final result = await post.unhide();
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post_actions']['hidden'], null);
      });
    });

    group('lock() method', () {
      test('should return the locked post', () async {
        final post = await client.post(id: postId!);
        final result = await post.lock(reason: 'Test reason');
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['locked'], true);
      });
    });

    group('unlock() method', () {
      test('should return the unlocked post', () async {
        final post = await client.post(id: postId!);
        await post.lock(reason: 'Test reason');

        final result = await post.unlock(reason: 'Test reason');
        expect(result, isA<Post>());

        final info = await result.info();
        expect(info['post_view']['post']['locked'], false);
      });
    });

    // group('edit() method', () {
    //   test('should return the edited post', () async {
    //     await client.account.login(username: username, password: password);

    //     final post = client.post(id: 1);
    //     final result = await post.edit(
    //       name: 'Test Post',
    //       body: 'This is a test post',
    //       nsfw: false,
    //     );
    //     expect(result, contains('post_view'));
    //   });
    // });

    // group('reply() method', () {
    //   test('should return the reply', () async {
    //     await client.account.login(username: username, password: password);

    //     final post = client.post(id: 1);
    //     final result = await post.reply(content: 'This is a reply');
    //     expect(result, contains('comment_view'));
    //   });
    // });
  });
}
