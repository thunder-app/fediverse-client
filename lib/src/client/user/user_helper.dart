import 'package:fediverse_client/src/client/client.dart';
import 'package:fediverse_client/src/client/user/user.dart';

/// This class defines a series of actions that can be performed on a user.
class UserHelper {
  final FediverseClient _client;

  UserHelper(this._client);

  Future<User> call({int? id, String? username}) => User.initialize(_client, id: id, username: username);
}
