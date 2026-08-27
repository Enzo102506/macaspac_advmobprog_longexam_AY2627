class Post {
  final int id;
  final int? postId;
  final int userId;
  final String body;
  final List<String> likes;
  final List<String> dislikes;
  final Map<String, int> reactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Post({
    required this.id,
    this.postId,
    required this.userId,
    required this.body,
    this.likes = const [],
    this.dislikes = const [],
    this.reactions = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final rawReactions = json['reactions'];
    final reactions = <String, int>{};

    if (rawReactions is Map) {
      rawReactions.forEach((key, value) {
        reactions[key.toString()] = int.tryParse(value?.toString() ?? '') ?? 0;
      });
    }

    return Post(
      id: _toInt(json['id'] ?? json['postId'] ?? 0),
      postId: json['postId'] == null ? null : _toInt(json['postId']),
      userId: _toInt(json['userId'] ?? 0),
      body: (json['body'] ?? json['content'] ?? '').toString(),
      likes: _toStringList(json['likes']),
      dislikes: _toStringList(json['dislikes']),
      reactions: reactions,
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseDate(
        json['updatedAt'] ??
            json['updated_at'] ??
            json['createdAt'] ??
            json['created_at'],
      ),
    );
  }

  static List<Post> fromJsonList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => Post.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'body': body,
      'likes': likes,
      'dislikes': dislikes,
      'reactions': reactions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value == null) {
      return const [];
    }
    return [value.toString()];
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
