import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

import '../config.dart';

void main() {
  group('Comment tests', () {
    late LemmyClient client;

    setUp(() async {
      client = await LemmyClient.initialize(instance: instance, scheme: scheme, version: version, userAgent: userAgent);
    });

    group('info() method', () {
      test('should return the comment information', () async {
        final comment = client.comment(id: '1');
        final result = await comment.info();
        expect(result, contains('comment_view'));
      });
    });
  });
}
