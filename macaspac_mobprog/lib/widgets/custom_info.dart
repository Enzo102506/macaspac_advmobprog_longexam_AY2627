import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import 'custom_font.dart';

class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.profileImage,
  });

  final String name;
  final String post;
  final String description;
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      color: FB_SECONDARY,
      child: Row(
        children: [
          CircleAvatar(
            radius: ScreenUtil().setSp(25),
            backgroundColor: FB_DARK_PRIMARY,
            backgroundImage: profileImage != null
                ? AssetImage(profileImage!)
                : null,
            child: profileImage == null
                ? Icon(Icons.person, size: 30.sp, color: FB_TEXT_COLOR_WHITE)
                : null,
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFont(
                text: name,
                fontSize: ScreenUtil().setSp(20),
                color: FB_TEXT_COLOR_WHITE,
                fontWeight: FontWeight.w800,
              ),
              CustomFont(
                text: 'Posted: $post',
                fontSize: ScreenUtil().setSp(13),
                color: FB_TEXT_COLOR_GRAY,
              ),
              CustomFont(
                text: description,
                fontSize: ScreenUtil().setSp(12),
                color: FB_TEXT_COLOR_GRAY,
                fontStyle: FontStyle.italic,
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz, color: FB_TEXT_COLOR_WHITE),
        ],
      ),
    );
  }
}
