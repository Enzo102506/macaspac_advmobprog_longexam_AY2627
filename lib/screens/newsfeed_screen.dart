import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  static const List<String> postImages = [
    'assets/images/post1.jpg',
    'assets/images/post2.jpg',
    'assets/images/post3.jpg',
    'assets/images/post4.jpg',
    'assets/images/post5.jpg',
    'assets/images/post6.jpg',
    'assets/images/post7.jpg',
    'assets/images/post8.jpg',
    'assets/images/post9.jpg',
  ];

  // 6 ads (5-7 required)
  static const List<Map<String, String>> ads = [
    {
      "image":
          "https://images.unsplash.com/photo-1767961932888-6bd98b732200?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "title": "Advertisement / Promotion",
      "market": "Buy 1 Take 1!",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=1200&q=60",
      "title": "Advertisement / Promotion",
      "market": "Limited Time Deal!",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=60",
      "title": "Advertisement / Promotion",
      "market": "New Drop Today!",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=1200&q=60",
      "title": "Advertisement / Promotion",
      "market": "Flash Sale ",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=1200&q=60",
      "title": "Advertisement / Promotion",
      "market": "50% OFF Today",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=60",
      "title": "Advertisement / Promotion",
      "market": "Free Shipping!",
    },
  ];

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  late Future<List<PostCard>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
  }

  Future<List<PostCard>> _loadFeed() async {
    final service = PostService();
    final results = await Future.wait([
      service.fetchPosts(),
      service.fetchUsers(),
    ]);
    final posts = results[0] as List<Post>;
    final users = {for (final user in results[1] as List<User>) user.id: user};

    return posts.map((post) {
      final user = users[post.userId];
      final content = post.title.isEmpty
          ? post.body
          : '${post.title}\n\n${post.body}';
      return PostCard(
        id: post.id,
        userName: user?.fullName.isNotEmpty == true
            ? user!.fullName
            : 'User #${post.userId}',
        postContent: content,
        imagePath: NewsFeedScreen
            .postImages[(post.id - 1) % NewsFeedScreen.postImages.length],
        initialLikes: post.reactions['likes'] ?? 0,
        numComments: 0,
        date: '',
        profileImageUrl: user?.image,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostCard>>(
      future: _feedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to load news feed. Pull to try again.',
              style: TextStyle(color: FB_TEXT_COLOR_WHITE),
              textAlign: TextAlign.center,
            ),
          );
        }

        final posts = snapshot.data ?? const <PostCard>[];
        final List<Widget> feedItems = [];
        final int alternateTimes = posts.length < 4 ? posts.length : 4;

        for (int i = 0; i < alternateTimes; i++) {
          feedItems.add(posts[i]);
          feedItems.add(const _AdvertisementBlock());
        }

        for (int i = alternateTimes; i < posts.length; i++) {
          feedItems.add(posts[i]);
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() => _feedFuture = _loadFeed());
            await _feedFuture;
          },
          child: ListView(
            padding: EdgeInsets.only(bottom: 12.h),
            children: feedItems,
          ),
        );
      },
    );
  }
}

class _AdvertisementBlock extends StatelessWidget {
  const _AdvertisementBlock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Enhancement 2: title above the items
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            child: CustomFont(
              text: "Advertisement/ Promotion",
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: FB_TEXT_COLOR_WHITE,
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: 435.h,
              padEnds: false,
              viewportFraction: 0.92,
            ),
            items: NewsFeedScreen.ads.map((ad) {
              return PostCard(
                userName: "YNSBOOKS",
                postContent: "MORE DETAILS\nIkaw na ito!",
                date: "Sponsored",
                initialLikes: 2000,
                numComments: 0,

                profileImageUrl:
                    "https://images.unsplash.com/photo-1520975693410-001c6ee04a2f?auto=format&fit=crop&w=256&q=60",
                imageUrl: ad["image"] ?? "",

                isAds: true,
                adsMarket: ad["market"] ?? "Advertisement",
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
