import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/user_session.dart';
import '../widgets/custom_font.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_PRIMARY,
      appBar: AppBar(
        backgroundColor: FB_PRIMARY,
        title: CustomFont(
          text: 'Settings',
          fontSize: 20.sp,
          color: FB_TEXT_COLOR_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingsTile(
              context,
              icon: Icons.person_outline,
              title: 'Account',
              subtitle: 'Manage your profile info',
            ),
            _settingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Customize alerts',
            ),
            _settingsTile(
              context,
              icon: Icons.lock_outline,
              title: 'Privacy',
              subtitle: 'Control your visibility',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<UserSession>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: FB_SECONDARY,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: FB_LIGHT_PRIMARY),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFont(
                  text: title,
                  fontSize: 16.sp,
                  color: FB_TEXT_COLOR_WHITE,
                  fontWeight: FontWeight.bold,
                ),
                CustomFont(
                  text: subtitle,
                  fontSize: 12.sp,
                  color: FB_TEXT_COLOR_GRAY,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: FB_TEXT_COLOR_GRAY),
        ],
      ),
    );
  }
}
