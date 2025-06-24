import 'package:test/test.dart';

import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/comment/comment.dart';
import 'package:fediverse_client/src/client/comment/comment_helper.dart';

import '../config.lemmy.dart';
import '../utils.dart';

void main() {
  group('Comment tests', () {
    late FediverseClient client;

    int? commentId;

    setUp(() async {
      client = await FediverseClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);

      await client.account.login(username: username, password: password);

      // Fetch a random community
      final community = await client.community.random();

      // Create a post in the community.
      final post = await community.submit(name: 'Test Post', body: 'This is a test post');

      // Create a comment on the post.
      final comment = await post.reply(content: 'This is a test comment');

      commentId = comment.id;
    });

    group('info() method', () {
      test('should return the comment information', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.info();
        expect(result, contains('comment_view'));
      });
    });

    group('edit() method', () {
      test('should return the edited comment', () async {
        final comment = await client.comment(id: commentId!);

        final editContent = generateRandomString(10);
        final result = await comment.edit(content: editContent);
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['content'], editContent);
      });
    });

    group('reply() method', () {
      test('should return the reply', () async {
        final content = generateRandomString(10);
        final comment = await client.comment(id: commentId!);

        final result = await comment.reply(content: content);
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['content'], content);
      });
    });

    group('replies() method', () {
      test('should return the replies for a given comment', () async {
        final comment = await client.comment(id: commentId!);

        // Create 10 replies to the comment
        for (int i = 0; i < 10; i++) {
          await comment.reply(content: 'This is a test reply $i');
        }

        final result = await comment.replies(sort: 'New', limit: 10);
        expect(result, isA<CommentListResult>());
      });
    });

    group('delete() method', () {
      test('should return the deleted comment', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.delete();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['deleted'], true);
      });
    });

    group('restore() method', () {
      test('should return the restored comment', () async {
        final comment = await client.comment(id: commentId!);

        await comment.delete();
        final result = await comment.restore();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['deleted'], false);
      });
    });

    group('remove() method', () {
      test('should return the removed comment', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.remove(reason: 'Test reason');
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['removed'], true);
      });
    });

    group('recover() method', () {
      test('should return the recovered comment', () async {
        final comment = await client.comment(id: commentId!);
        await comment.remove(reason: 'Test reason');

        final result = await comment.recover(reason: 'Test reason');
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment']['removed'], false);
      });
    });

    group('vote() method', () {
      test('should return the voted comment', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.vote(score: 1);
        expect(result, isA<Comment>());

        Map<String, dynamic> info = await result.info();
        expect(info['comment_view']['comment']['score'], 1);

        // Vote again with a different score
        final result2 = await comment.vote(score: -1);
        expect(result2, isA<Comment>());

        info = await result2.info();
        expect(info['comment_view']['comment']['score'], -1);
      });
    });

    group('save() method', () {
      test('should return the saved comment', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.save();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment_actions']['saved'], isNot(null));
      });

      test('should return the unsaved comment', () async {
        final comment = await client.comment(id: commentId!);
        await comment.save();

        final result = await comment.unsave();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment_actions']['saved'], null);
      });
    });

    // TODO: Fix this test - should create a comment reply first
    // Create a comment from the current user
    // Create a reply to the comment from a different user
    group('read() method', () {
      test('should return the read comment reply', () async {
        final comment = await client.comment(id: commentId!);
        final result = await comment.read();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment_actions']['read'], isNot(null));
      });

      test('should return the unread comment reply', () async {
        final comment = await client.comment(id: commentId!);
        await comment.read();

        final result = await comment.unread();
        expect(result, isA<Comment>());

        final info = await result.info();
        expect(info['comment_view']['comment_actions']['read'], null);
      });
    });
  });
}
