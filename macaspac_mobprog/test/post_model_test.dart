import 'package:flutter_test/flutter_test.dart';
import 'package:macaspac_mobprog/models/post.dart';

void main() {
  group('Post model', () {
    test('fromJson should parse post data and normalize arrays', () {
      final post = Post.fromJson({
        'id': 1,
        'postId': 99,
        'userId': 7,
        'body': 'Hello from the app',
        'likes': ['alice', 'bob'],
        'dislikes': ['charlie'],
        'reactions': {'love': 2, 'wow': 1},
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-02T00:00:00.000Z',
      });

      expect(post.id, 1);
      expect(post.postId, 99);
      expect(post.userId, 7);
      expect(post.body, 'Hello from the app');
      expect(post.likes, ['alice', 'bob']);
      expect(post.dislikes, ['charlie']);
      expect(post.reactions['love'], 2);
      expect(post.createdAt.isAfter(DateTime(2023, 12, 31)), isTrue);
      expect(post.toJson()['body'], 'Hello from the app');
    });
  });
}
