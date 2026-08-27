import 'package:flutter_test/flutter_test.dart';
import 'package:macaspac_mobprog/models/user.dart';

void main() {
  group('User model', () {
    test('fromJson should parse dummyjson auth payload with token', () {
      final user = User.fromJson({
        'id': 1,
        'username': 'kminchelle',
        'email': 'kminchelle@qq.com',
        'firstName': 'Jeanne',
        'lastName': 'Halvorson',
        'image': 'https://example.com/avatar.png',
        'token': 'abc123',
      });

      expect(user.username, 'kminchelle');
      expect(user.email, 'kminchelle@qq.com');
      expect(user.fullName, 'Jeanne Halvorson');
      expect(user.token, 'abc123');
      expect(user.toJson()['username'], 'kminchelle');
    });
  });
}
