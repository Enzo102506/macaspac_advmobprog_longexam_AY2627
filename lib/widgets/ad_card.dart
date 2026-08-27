import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constant.dart';
import 'custom_font.dart';

class AdCard extends StatelessWidget {
  final String title;
  final String market;
  final String imageUrl;

  const AdCard({
    super.key,
    required this.title,
    required this.market,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                CircleAvatar(radius: 18.r),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: FB_TEXT_COLOR_WHITE,
                    ),
                    CustomFont(
                      text: "Sponsored",
                      fontSize: 11.sp,
                      color: FB_TEXT_COLOR_GRAY,
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.more_horiz, color: FB_TEXT_COLOR_WHITE),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: CustomFont(
              text: market,
              fontSize: 14.sp,
              color: FB_TEXT_COLOR_WHITE,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // 🔥 RESPONSIVE IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
