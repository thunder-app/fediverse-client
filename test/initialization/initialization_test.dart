import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:lemmy_dart_client/src/client/client.dart';

// Import the auth token from the config file
import '../config.dart';

void main() {
  late LemmyClient client;

  setUpAll(() async {
    client = await LemmyClient.initialize(
      instance: instance,
      version: version,
      scheme: scheme,
    );
  });

  group('Client', () {
    test('should fetch the proper information when initialized', () async {
      expect(client.site.info, isNotNull);
      expect(client.account.info, isNull);
    });

    test('should fail when an invalid instance is given', () async {
      expect(
        () async => await LemmyClient.initialize(instance: 'invalid'),
        throwsA(isA<ClientException>()),
      );
    });

    // test('should fetch the proper account information when initialized', () async {
    //   final client = await LemmyClient.initialize(auth: auth);
    //   expect(client.site.info, isNotNull);
    //   expect(client.account.info, isNotNull);
    // });

    // test('should not have account information if no auth is passed in', () async {
    //   final client = await LemmyClient.initialize(auth: 'invalid');
    //   expect(client.site.info, isNotNull);
    //   expect(client.account.info, isNull);
    // });
  });
}
