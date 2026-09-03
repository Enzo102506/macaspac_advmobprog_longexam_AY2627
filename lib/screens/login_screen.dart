import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/user_session.dart';
import '../services/auth_service.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _hidePass = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _userCtrl.text.trim();
    final pass = _passCtrl.text;

    if (username.isEmpty || pass.isEmpty) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Invalid Input',
        message: 'Please enter your username and password.',
      );
      return;
    }

    try {
      final loggedUser = await AuthService.login(
        username: username,
        password: pass,
      );

      if (loggedUser == null) {
        await CustomDialogs.showMessage(
          context: context,
          title: 'Login Failed',
          message:
              'Invalid credentials. Try a DummyJSON demo account like emilys / emilyspass.',
        );
        return;
      }

      await context.read<UserSession>().login(
        loggedUser.username,
        user: loggedUser,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Login Error',
        message:
            'Unable to connect to the authentication service. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_PRIMARY,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ LOGO ON TOP OF TITLE
                CircleAvatar(
                  radius: 55.r,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage('assets/icons/logo1.jpeg'),
                ),

                SizedBox(height: 18.h),

                // TITLE
                CustomFont(
                  text: "YNsbook Login",
                  fontSize: 28.sp,
                  color: FB_TEXT_COLOR_WHITE,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 24.h),

                // USERNAME / EMAIL
                CustomTextFormField(
                  controller: _userCtrl,
                  hintText: "Username / Email",
                  prefixIcon: Icons.person,
                ),

                SizedBox(height: 12.h),

                // PASSWORD
                CustomTextFormField(
                  controller: _passCtrl,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: _hidePass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePass ? Icons.visibility_off : Icons.visibility,
                      color: FB_TEXT_COLOR_GRAY,
                    ),
                    onPressed: () => setState(() => _hidePass = !_hidePass),
                  ),
                ),

                SizedBox(height: 20.h),

                // LOGIN BUTTON
                CustomInkwellButton(buttonName: "Login", onTap: _login),

                SizedBox(height: 12.h),

                // REGISTER LINK
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: CustomFont(
                    text: "No account? Register here",
                    fontSize: 14.sp,
                    color: FB_LIGHT_PRIMARY,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
