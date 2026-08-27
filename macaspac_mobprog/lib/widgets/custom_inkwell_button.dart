import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import 'custom_font.dart';

class CustomInkwellButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const CustomInkwellButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.h,
        decoration: BoxDecoration(
          color: FB_LIGHT_PRIMARY,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: CustomFont(
          text: buttonName,
          fontSize: 16.sp,
          color: FB_PRIMARY,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
