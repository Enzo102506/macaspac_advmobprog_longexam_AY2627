import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'constant.dart';
import 'providers/user_session.dart';

import 'screens/home_screen.dart';
import 'screens/newsfeed_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const EnzoFacebook());

class EnzoFacebook extends StatelessWidget {
  const EnzoFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return ChangeNotifierProvider(
          create: (_) => UserSession(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Facebook Replication',
            initialRoute: '/splash',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/newsfeed': (context) => const NewsFeedScreen(),
              '/detail': (context) => const DetailScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/splash': (context) => const SplashScreen(),
            },
            theme: ThemeData(
              useMaterial3: false,
              scaffoldBackgroundColor: FB_PRIMARY,
              primaryColor: FB_LIGHT_PRIMARY,
              colorScheme: const ColorScheme.dark(
                primary: FB_LIGHT_PRIMARY,
                secondary: FB_LIGHT_PRIMARY,
                surface: FB_SECONDARY,
                onPrimary: FB_TEXT_COLOR_WHITE,
                onSurface: FB_TEXT_COLOR_WHITE,
              ),
              cardColor: FB_SECONDARY,
              dividerColor: Colors.white24,
              appBarTheme: const AppBarTheme(
                backgroundColor: FB_PRIMARY,
                foregroundColor: FB_TEXT_COLOR_WHITE,
                elevation: 0,
              ),
              textTheme: Typography.whiteMountainView.apply(
                bodyColor: FB_TEXT_COLOR_WHITE,
                displayColor: FB_TEXT_COLOR_WHITE,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FB_LIGHT_PRIMARY,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
