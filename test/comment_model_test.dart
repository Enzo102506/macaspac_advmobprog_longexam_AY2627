import 'package:flutter_test/flutter_test.dart';
import 'package:macaspac_mobprog/models/comment.dart';

void main() {
  group('Comment model', () {
    test('fromJson should parse dummyjson comment payload', () {
      final comment = Comment.fromJson({
        'id': 12,
        'body': 'Nice post!',
        'postId': 7,
        'user': {'id': 3, 'username': 'johndoe'},
      });

      expect(comment.id, 12);
      expect(comment.postId, 7);
      expect(comment.userId, 3);
      expect(comment.body, 'Nice post!');
      expect(comment.userName, 'johndoe');
    });
  });
}
