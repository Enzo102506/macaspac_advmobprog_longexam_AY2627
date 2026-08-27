import 'package:flutter/material.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';

class NotificationData {
  final String user;
  final String action;
  final String? profileImage;
  final String? postImage;
  final String? postContent;
  final String postDate;

  const NotificationData({
    required this.user,
    required this.action,
    this.profileImage,
    this.postImage,
    this.postContent,
    this.postDate = 'January 1',
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<NotificationData> _notificationData = const [
    NotificationData(
      user: 'Enzo Kurosaki',
      action: 'posted a new photo',
      profileImage: 'assets/images/profile1.jpg',
      postImage: 'assets/images/post1.jpg',
      postContent: 'Nagugutom ako',
      postDate: 'December 1',
    ),
    NotificationData(
      user: 'NETTSPED',
      action: 'posted a new song',
      profileImage: 'assets/images/post2.jpg',
      postImage: 'assets/images/post2.jpg',
      postContent: 'That one song',
      postDate: 'November 28',
    ),
    NotificationData(
      user: 'Lebron James',
      action: 'shared a new post',
      profileImage: 'assets/images/profile3.jpg',
      postImage: 'assets/images/post3.jpg',
      postContent: 'LETS GO MERALCO BOLTS!!',
      postDate: 'November 1',
    ),
    NotificationData(
      user: 'Stephen Curry',
      action: 'commented on your post',
      profileImage: 'assets/images/Steph1.jpg',
      postImage: 'assets/images/post4.jpg',
      postContent: 'Pina isa lang gusto pa manalo',
      postDate: 'October 28',
    ),
    // Post 5 - Alvin
    NotificationData(
      user: 'Alvin',
      action: 'posted a new photo',
      profileImage: 'assets/images/post5.jpg',
      postImage: 'assets/images/post5.jpg',
      postContent: 'My Sunshine <3',
      postDate: 'January 9',
    ),
    // Post 6 - Post Maloni
    NotificationData(
      user: 'Post Maloni',
      action: 'posted a new photo',
      profileImage: 'assets/images/post6.jpg',
      postImage: 'assets/images/post6.jpg',
      postContent: 'Post ko langs',
      postDate: 'January 10',
    ),
    // Post 7 - JAMAL
    NotificationData(
      user: 'JAMAL',
      action: 'posted a new photo',
      profileImage: 'assets/images/jamal7.jpg',
      postImage: 'assets/images/post7.jpg',
      postContent: 'Holynige',
      postDate: 'January 11',
    ),
    // Post 8 - PINIWAIS
    NotificationData(
      user: 'PINIWAIS',
      action: 'posted a new photo',
      profileImage: 'assets/images/post8.jpg',
      postImage: 'assets/images/post8.jpg',
      postContent: 'TIME TO PLOWT',
      postDate: 'January 11',
    ),
    // Post 9 - JAMEER
    NotificationData(
      user: 'JAMEER',
      action: 'posted a new photo',
      profileImage: 'assets/images/profile9.jpg',
      postImage: 'assets/images/post9.jpg',
      postContent: 'Welcome to earf',
      postDate: 'January 11',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: ListView.separated(
        itemCount: _notificationData.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _notificationData[index];
          String descriptionText = '${data.user} ${data.action}';

          // Make notification clickable → opens DetailScreen
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: PostCard(
                  userName: data.user,
                  profileImage: data.profileImage,
                  postContent: data.postContent ?? '',
                  date: data.postDate,
                  initialLikes: 0,
                  numComments: 0,
                  imagePath: data.postImage,
                ),
              );
            },
            child: CustomInformation(
              name: data.user,
              post: data.postContent ?? '',
              description: descriptionText,
              profileImage: data.profileImage,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1, color: Color(0xFF303F9F));
        },
      ),
    );
  }
}
