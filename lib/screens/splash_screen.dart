import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/user_session.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/custom_font.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = context.read<UserSession>();
    await session.loadSession();

    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (session.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_PRIMARY,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55.r,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/icons/logo1.jpeg'),
            ),

            SizedBox(height: 16.h),

            CustomFont(
              text: "YNsBook",
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: FB_TEXT_COLOR_WHITE,
              letterSpacing: 1.2,
            ),

            SizedBox(height: 20.h),

            const BouncingDotsLoading(dotSize: 12, color: FB_LIGHT_PRIMARY),
          ],
        ),
      ),
    );
  }
}
