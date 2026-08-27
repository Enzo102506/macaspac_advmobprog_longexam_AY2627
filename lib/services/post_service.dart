import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/post.dart';

class PostService {
  final String baseUrl;
  final http.Client client;

  PostService({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? 'https://jsonplaceholder.typicode.com',
      client = client ?? http.Client();

  Future<List<Post>> fetchPosts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$baseUrl/posts?limit=$limit&skip=$skip');

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map && decoded.containsKey('posts')) {
        return Post.fromJsonList(decoded['posts']);
      }

      return Post.fromJsonList(decoded);
    }

    throw Exception('Failed to load posts: ${response.statusCode}');
  }

  Future<Post> fetchPostById(int postId) async {
    final uri = Uri.parse('$baseUrl/posts/$postId');

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return Post.fromJson(Map<String, dynamic>.from(decoded as Map));
    }

    throw Exception('Failed to load post: ${response.statusCode}');
  }

  Future<Post> createPost({required int userId, required String body}) async {
    final uri = Uri.parse('$baseUrl/posts');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'body': body}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return Post.fromJson(Map<String, dynamic>.from(decoded as Map));
    }

    throw Exception('Failed to create post: ${response.statusCode}');
  }

  Future<List<Post>> fetchPostsByUserId(int userId) async {
    final endpoints = [
      Uri.parse('https://dummyjson.com/posts/user/$userId'),
      Uri.parse('https://dummyjson.com/users/$userId/posts'),
    ];

    for (final uri in endpoints) {
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is Map && decoded.containsKey('posts')
            ? decoded['posts']
            : decoded;

        if (data is List) {
          return data
              .map(
                (item) => Post.fromJson(Map<String, dynamic>.from(item as Map)),
              )
              .toList();
        }
      }
    }

    throw Exception('Failed to load posts for user $userId');
  }

  Future<List<Comment>> fetchCommentsByPostId(int postId) async {
    final uri = Uri.parse('https://dummyjson.com/comments/post/$postId');
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded is Map && decoded.containsKey('comments')
          ? decoded['comments']
          : decoded;

      if (data is List) {
        return data
            .map(
              (item) =>
                  Comment.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
      }
    }

    throw Exception('Failed to load comments for post $postId');
  }

  Future<Comment> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final uri = Uri.parse('https://dummyjson.com/comments/add');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return Comment.fromJson(Map<String, dynamic>.from(decoded as Map));
    }

    throw Exception('Failed to add comment');
  }
}
