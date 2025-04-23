import 'dart:math';

String generateRandomString(int length) {
  var r = Random();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return List.generate(length, (index) => chars[r.nextInt(chars.length)]).join();
}
