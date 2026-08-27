import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: FB_TEXT_COLOR_WHITE, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: FB_TEXT_COLOR_GRAY, fontSize: 14.sp),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: FB_TEXT_COLOR_GRAY)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: FB_SECONDARY,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
