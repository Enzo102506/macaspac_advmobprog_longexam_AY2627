import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/post.dart';
import '../providers/user_session.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0;
  bool isLoadingPosts = true;
  List<PostCard> profilePosts = [];

  @override
  void initState() {
    super.initState();
    _loadProfilePosts();
  }

  Future<void> _loadProfilePosts() async {
    final session = context.read<UserSession>();
    final userId = session.user?.id ?? 0;

    if (userId == 0) {
      setState(() => isLoadingPosts = false);
      return;
    }

    try {
      final posts = await PostService().fetchPostsByUserId(userId);
      final cards = posts.map((post) {
        final date = post.createdAt.toLocal().toString().split(' ').first;
        final userName = session.profileDisplayName;

        return PostCard(
          userName: userName,
          postContent: post.body,
          date: date,
          initialLikes: post.reactions.isEmpty
              ? 0
              : post.reactions.values.fold<int>(0, (sum, value) => sum + value),
          numComments: post.reactions.isEmpty ? 0 : post.reactions.length,
          imageUrl: '',
          profileImageUrl: session.user?.image ?? '',
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        profilePosts = cards;
        isLoadingPosts = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoadingPosts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileName = context.watch<UserSession>().profileDisplayName;
    final userImage = context.watch<UserSession>().user?.image;

    return Scaffold(
      backgroundColor: FB_PRIMARY,
      appBar: AppBar(
        backgroundColor: FB_PRIMARY,
        title: CustomFont(
          text: profileName,
          fontSize: 20.sp,
          color: FB_TEXT_COLOR_WHITE,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(
              Icons.settings_outlined,
              color: FB_TEXT_COLOR_WHITE,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= COVER + PROFILE =================
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/cover1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -45.h,
                  left: 16.w,
                  child: CircleAvatar(
                    radius: 45.r,
                    backgroundColor: FB_PRIMARY,
                    child: CircleAvatar(
                      radius: 42.r,
                      backgroundImage: userImage != null && userImage.isNotEmpty
                          ? NetworkImage(userImage)
                          : const AssetImage('assets/images/profile1.jpg')
                                as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 55.h),

            // ================= PROFILE INFO =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: profileName,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: FB_TEXT_COLOR_WHITE,
                  ),
                  SizedBox(height: 6.h),
                  CustomFont(
                    text: "10.8m followers   5000 following",
                    fontSize: 13.sp,
                    color: FB_TEXT_COLOR_GRAY,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(text: "Follow", onPressed: () {}),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          text: "Message",
                          onPressed: () {},
                          isOutlined: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            Divider(color: FB_SECONDARY),

            // ================= TABS =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  _tabItem("Posts", 0),
                  _tabItem("About", 1),
                  _tabItem("Photos", 2),
                ],
              ),
            ),
            Divider(color: FB_SECONDARY),

            if (selectedTab == 0) _postsTab(),
            if (selectedTab == 1) _aboutTab(),
            if (selectedTab == 2) _photosTab(),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    final bool isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Padding(
        padding: EdgeInsets.only(right: 20.w, bottom: 8.h),
        child: Column(
          children: [
            CustomFont(
              text: text,
              fontSize: 14.sp,
              color: isActive ? FB_TEXT_COLOR_WHITE : FB_TEXT_COLOR_GRAY,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            if (isActive)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                height: 2.h,
                width: 30.w,
                color: FB_TEXT_COLOR_WHITE,
              ),
          ],
        ),
      ),
    );
  }

  Widget _postsTab() {
    if (isLoadingPosts) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(color: FB_LIGHT_PRIMARY),
        ),
      );
    }

    if (profilePosts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: CustomFont(
          text: 'No posts found for this user yet.',
          fontSize: 14,
          color: FB_TEXT_COLOR_GRAY,
        ),
      );
    }

    return Column(children: profilePosts);
  }

  Widget _aboutTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomFont(
        text:
            "Tech enthusiast who loves gaming and exploring new technologies.",
        fontSize: 14.sp,
        color: FB_TEXT_COLOR_GRAY,
      ),
    );
  }

  // ✅ PDF asks to revise/edit photos section: make images tappable + open dialog
  Widget _photosTab() {
    final List<String> photos = [
      'assets/images/post1.jpg',
      'assets/images/post2.jpg',
      'assets/images/post3.jpg',
      'assets/images/post4.jpg',
      'assets/images/post5.jpg',
      'assets/images/post6.jpg',
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // ✅ Uses your dynamic image dialog (supports asset + network, with close icon)
              CustomDialogs.showImageDialog(
                context: context,
                imageUrl: photos[index],
                height: 320,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(photos[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
