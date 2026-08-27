class Comment {
  final int id;
  final int postId;
  final int userId;
  final String body;
  final String userName;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.userName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final username = user is Map ? (user['username'] ?? '').toString() : '';

    return Comment(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      postId: int.tryParse('${json['postId'] ?? 0}') ?? 0,
      userId:
          int.tryParse(
            '${json['userId'] ?? (user is Map ? user['id'] ?? 0 : 0)}',
          ) ??
          0,
      body: (json['body'] ?? '').toString(),
      userName: username.isNotEmpty ? username : 'User',
      createdAt:
          DateTime.tryParse(
            '${json['createdAt'] ?? DateTime.now().toIso8601String()}',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'body': body,
      'user': {'id': userId, 'username': userName},
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
