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

  group('Site Details', () {
    test('should fetch the current instance details', () async {
      final result = client.site.info;
      expect(result, isNotNull);
    });

    test('should fetch the updated current instance details', () async {
      final result = client.site.refresh();
      expect(result, isNotNull);
    });
  });

  group('[NOT IMPLEMENTED] Site Administration', () {
    test('should fail to create a site', () async {
      expect(() => client.site.create(), throwsException);
    });

    test('should fail to edit a site', () async {
      expect(() => client.site.edit(), throwsException);
    });
  });
}
