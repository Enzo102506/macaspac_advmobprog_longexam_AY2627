import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import 'custom_font.dart';

class PostCard extends StatefulWidget {
  final int? id;
  final String userName;
  final String postContent;
  final String date;
  final int initialLikes;
  final int numComments;

  // Existing (asset-based)
  final String? imagePath;
  final String? profileImage;

  // NEW (network-based)
  final String? imageUrl;
  final String? profileImageUrl;

  // NEW (ads)
  final bool isAds;
  final String? adsMarket;

  const PostCard({
    super.key,
    this.id,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.initialLikes,
    required this.numComments,
    this.imagePath,
    this.profileImage,

    // NEW optional params (won’t break old code)
    this.imageUrl,
    this.profileImageUrl,
    this.isAds = false,
    this.adsMarket,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int numLikes;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    numLikes = widget.initialLikes;
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

  Widget _buildAvatar() {
    // Network avatar
    if (widget.profileImageUrl != null && widget.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: FB_DARK_PRIMARY,
        backgroundImage: CachedNetworkImageProvider(widget.profileImageUrl!),
      );
    }

    // Asset avatar
    if (widget.profileImage != null && widget.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: FB_DARK_PRIMARY,
        backgroundImage: AssetImage(widget.profileImage!),
      );
    }

    // Placeholder
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: FB_DARK_PRIMARY,
      child: Icon(Icons.person, color: FB_TEXT_COLOR_WHITE),
    );
  }

  Widget _buildPostImage() {
    // Network post image
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200.h,
          color: Colors.grey[700],
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200.h,
          color: Colors.grey[700],
          alignment: Alignment.center,
          child: Icon(Icons.error, size: 50.sp, color: FB_TEXT_COLOR_WHITE),
        ),
      );
    }

    // Asset post image
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      return Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          image: DecorationImage(
            image: AssetImage(widget.imagePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Placeholder
    return Container(
      height: 200.h,
      width: double.infinity,
      color: Colors.grey[700],
      child: Icon(Icons.image, size: 50.sp, color: FB_TEXT_COLOR_WHITE),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: widget);
      },
      child: Card(
        color: Colors.grey[800],
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: widget.userName,
                            fontSize: 16.sp,
                            color: FB_TEXT_COLOR_WHITE,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomFont(
                            text: widget.date,
                            fontSize: 12.sp,
                            color: FB_TEXT_COLOR_GRAY,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.more_horiz, color: FB_TEXT_COLOR_WHITE),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // If ad, you can still show postContent; but we’ll also show adsMarket label
                  if (widget.postContent.isNotEmpty)
                    CustomFont(
                      text: widget.postContent,
                      fontSize: 14.sp,
                      color: FB_TEXT_COLOR_WHITE,
                    ),

                  if (widget.isAds && (widget.adsMarket ?? '').isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    CustomFont(
                      text: widget.adsMarket!,
                      fontSize: 14.sp,
                      color: FB_TEXT_COLOR_WHITE,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ],
              ),
            ),

            _buildPostImage(),

            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  CustomFont(
                    text: '$numLikes Likes',
                    fontSize: 12.sp,
                    color: FB_TEXT_COLOR_WHITE,
                  ),
                  SizedBox(width: 10.w),
                  CustomFont(
                    text: '${widget.numComments} Comments',
                    fontSize: 12.sp,
                    color: FB_TEXT_COLOR_WHITE,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[600]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  iconColor: isLiked ? Colors.blue : FB_LIGHT_PRIMARY,
                  label: 'Like',
                  onPressed: _toggleLike,
                ),
                _ActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  onPressed: () {},
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor ?? FB_LIGHT_PRIMARY),
      label: CustomFont(
        text: label,
        fontSize: 14.sp,
        color: iconColor ?? FB_LIGHT_PRIMARY,
      ),
    );
  }
}
