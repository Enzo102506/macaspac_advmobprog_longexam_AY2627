import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/user_session.dart';
import '../widgets/custom_font.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onTappedBar(int value) {
    setState(() => _selectedIndex = value);
    _pageController.jumpToPage(value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileName = context.watch<UserSession>().profileDisplayName;

    return Scaffold(
      backgroundColor: FB_PRIMARY,
      appBar: AppBar(
        title: CustomFont(
          text: _selectedIndex == 0
              ? 'YNsbook'
              : _selectedIndex == 1
                  ? 'Notifications'
                  : profileName,
          fontSize: 25.sp,
          color: FB_TEXT_COLOR_WHITE,
          fontFamily: 'Klavika',
        ),
        backgroundColor: FB_PRIMARY,
        elevation: 2,
      ),
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          NewsFeedScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (page) => setState(() => _selectedIndex = page),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: FB_SECONDARY,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: FB_LIGHT_PRIMARY,
        unselectedItemColor: FB_TEXT_COLOR_GRAY,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
