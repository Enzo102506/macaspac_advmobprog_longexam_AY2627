import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/comment.dart';
import '../providers/user_session.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PostCard post;
  late int numLikes;
  bool isLiked = false;
  bool isLoadingComments = true;
  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    post = ModalRoute.of(context)!.settings.arguments as PostCard;
    numLikes = post.initialLikes;
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final fetched = await PostService().fetchCommentsByPostId(post.id ?? 0);
      if (!mounted) return;
      setState(() {
        comments = fetched;
        isLoadingComments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoadingComments = false);
    }
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        numLikes--;
      } else {
        numLikes++;
      }
      isLiked = !isLiked;
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<UserSession>().user;
    if (user == null) return;

    try {
      final newComment = await PostService().addComment(
        postId: post.id ?? 0,
        userId: user.id,
        body: text,
      );

      if (!mounted) return;
      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to add comment right now.')),
      );
    }
  }

  Widget _detailPostImage() {
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: post.imageUrl!,
        width: double.infinity,
        height: 300.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: 300.h,
          color: Colors.grey[700],
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: 300.h,
          color: Colors.grey[700],
          alignment: Alignment.center,
          child: const Icon(Icons.error),
        ),
      );
    }

    if (post.imagePath != null) {
      return Container(
        width: double.infinity,
        height: 300.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(post.imagePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 300.h,
      color: Colors.grey[700],
      child: Icon(Icons.image, size: 100.sp, color: FB_TEXT_COLOR_WHITE),
    );
  }

  ImageProvider? _detailAvatarProvider() {
    if (post.profileImageUrl != null && post.profileImageUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(post.profileImageUrl!);
    }
    if (post.profileImage != null) {
      return AssetImage(post.profileImage!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_PRIMARY,
      appBar: AppBar(
        title: CustomFont(
          text: "Post Detail",
          fontSize: 20.sp,
          color: FB_TEXT_COLOR_WHITE,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: FB_PRIMARY,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _detailPostImage(),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: FB_DARK_PRIMARY,
                    backgroundImage: _detailAvatarProvider(),
                    child: _detailAvatarProvider() == null
                        ? Icon(
                            Icons.person,
                            size: 30.sp,
                            color: FB_TEXT_COLOR_WHITE,
                          )
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: post.userName,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: FB_TEXT_COLOR_WHITE,
                      ),
                      CustomFont(
                        text: post.date,
                        fontSize: 12.sp,
                        color: FB_TEXT_COLOR_GRAY,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomFont(
                text: post.postContent,
                fontSize: 14.sp,
                color: FB_TEXT_COLOR_WHITE,
              ),
            ),

            if (post.isAds && (post.adsMarket ?? '').isNotEmpty) ...[
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomFont(
                  text: post.adsMarket!,
                  fontSize: 14.sp,
                  color: FB_TEXT_COLOR_WHITE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CustomFont(
                    text: "$numLikes Likes",
                    fontSize: 14.sp,
                    color: FB_TEXT_COLOR_WHITE,
                  ),
                  SizedBox(width: 10.w),
                  CustomFont(
                    text: "${comments.length} Comments",
                    fontSize: 14.sp,
                    color: FB_TEXT_COLOR_WHITE,
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey[600]),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _toggleLike,
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: isLiked ? Colors.blue : FB_LIGHT_PRIMARY,
                    ),
                    label: CustomFont(
                      text: "Like",
                      fontSize: 14.sp,
                      color: isLiked ? Colors.blue : FB_LIGHT_PRIMARY,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment_outlined,
                      color: FB_LIGHT_PRIMARY,
                    ),
                    label: CustomFont(
                      text: "Comment",
                      fontSize: 14.sp,
                      color: FB_LIGHT_PRIMARY,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      color: FB_LIGHT_PRIMARY,
                    ),
                    label: CustomFont(
                      text: "Share",
                      fontSize: 14.sp,
                      color: FB_LIGHT_PRIMARY,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: FB_TEXT_COLOR_WHITE),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: const TextStyle(color: FB_TEXT_COLOR_GRAY),
                        filled: true,
                        fillColor: FB_SECONDARY,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: _addComment,
                    icon: const Icon(Icons.send, color: FB_LIGHT_PRIMARY),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            if (isLoadingComments)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: FB_LIGHT_PRIMARY),
              )
            else if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomFont(
                  text: 'No comments yet.',
                  fontSize: 14.sp,
                  color: FB_TEXT_COLOR_GRAY,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: FB_SECONDARY,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: comment.userName,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: FB_TEXT_COLOR_WHITE,
                        ),
                        SizedBox(height: 4.h),
                        CustomFont(
                          text: comment.body,
                          fontSize: 13.sp,
                          color: FB_TEXT_COLOR_GRAY,
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
