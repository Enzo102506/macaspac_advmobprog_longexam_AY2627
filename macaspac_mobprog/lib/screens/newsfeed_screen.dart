import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  // 6 ads (5–7 required)
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
      "market": "Flash Sale 🔥",
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
  Widget build(BuildContext context) {
    // Your original posts (assets) — unchanged
    final List<PostCard> posts = [
      const PostCard(
        id: 1,
        userName: 'Enzo Kurosaki',
        profileImage: 'assets/images/profile1.jpg',
        postContent: 'Nagugutom ako',
        initialLikes: 43,
        numComments: 13,
        date: 'December 1',
        imagePath: 'assets/images/post1.jpg',
      ),
      const PostCard(
        id: 2,
        userName: 'NETTSPED',
        profileImage: 'assets/images/post2.jpg',
        postContent: 'That one song',
        initialLikes: 12932,
        numComments: 542,
        date: 'November 28',
        imagePath: 'assets/images/post2.jpg',
      ),
      const PostCard(
        id: 3,
        userName: 'Lebron James',
        profileImage: 'assets/images/profile3.jpg',
        postContent: 'LETS GO MERALCO BOLTS!!',
        initialLikes: 431528,
        numComments: 5344,
        date: 'November 1',
        imagePath: 'assets/images/post3.jpg',
      ),
      const PostCard(
        id: 4,
        userName: 'Stephen Curry',
        profileImage: 'assets/images/Steph1.jpg',
        postContent: 'Pina isa lang gusto pa manalo',
        initialLikes: 231,
        numComments: 1,
        date: 'October 28',
        imagePath: 'assets/images/post4.jpg',
      ),

      // extra posts remain below (we’ll still display them after alternating)
      const PostCard(
        id: 5,
        userName: 'Alvin',
        profileImage: 'assets/images/post5.jpg',
        postContent: 'My Sunshine <3',
        initialLikes: 32,
        numComments: 0,
        date: 'January 9',
        imagePath: 'assets/images/post5.jpg',
      ),
      const PostCard(
        id: 6,
        userName: 'Post Maloni',
        profileImage: 'assets/images/post6.jpg',
        postContent: 'Post ko langs',
        initialLikes: 4123,
        numComments: 0,
        date: 'January 10',
        imagePath: 'assets/images/post6.jpg',
      ),
      const PostCard(
        id: 7,
        userName: 'JAMAL',
        profileImage: 'assets/images/jamal7.jpg',
        postContent: 'Holynige',
        initialLikes: 21312,
        numComments: 0,
        date: 'January 11',
        imagePath: 'assets/images/post7.jpg',
      ),
      const PostCard(
        id: 8,
        userName: 'PINIWAIS',
        profileImage: 'assets/images/post8.jpg',
        postContent: 'TIME TO PLOWT',
        initialLikes: 412423,
        numComments: 0,
        date: 'January 11',
        imagePath: 'assets/images/post8.jpg',
      ),
      const PostCard(
        id: 9,
        userName: 'JAMEER',
        profileImage: 'assets/images/post9.jpg',
        postContent: 'Welcome to earf',
        initialLikes: 2312545,
        numComments: 0,
        date: 'January 11',
        imagePath: 'assets/images/profile9.jpg',
      ),
    ];

    // ✅ Enhancement 1: alternate Post + Ad 4 times
    final List<Widget> feedItems = [];
    final int alternateTimes = 4; // 3–4 times required

    for (int i = 0; i < alternateTimes; i++) {
      feedItems.add(posts[i]);
      feedItems.add(const _AdvertisementBlock());
    }

    // Add remaining posts after alternating
    for (int i = alternateTimes; i < posts.length; i++) {
      feedItems.add(posts[i]);
    }

    return ListView(
      padding: EdgeInsets.only(bottom: 12.h),
      children: feedItems,
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
