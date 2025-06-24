import 'package:test/test.dart';

import 'package:fediverse_client/fediverse_client.dart';

import 'config.lemmy.dart';

void main() {
  late FediverseClient client;

  setUp(() async {
    client = await FediverseClient.initialize(
      instance: instance,
      scheme: scheme,
      version: version,
      userAgent: userAgent,
    );
  });

  group('FediverseClient', () {
    test('initializes successfully', () {
      expect(client, isNotNull);
      expect(client.host, equals(instance));
      expect(client.scheme, equals(scheme));
      expect(client.version, equals(version));
    });
  });
}
