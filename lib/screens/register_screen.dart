import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fnameCtrl = TextEditingController();
  final _lnameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _fnameCtrl.dispose();
    _lnameCtrl.dispose();
    _mobileCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ✅ Strong password rule like your screenshot
  bool _isStrongPassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecial =
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]').hasMatch(password);

    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecial;
  }

  Future<void> _register() async {
    final fname = _fnameCtrl.text.trim();
    final lname = _lnameCtrl.text.trim();
    final mobile = _mobileCtrl.text.trim();
    final user = _userCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if ([fname, lname, mobile, user].any((v) => v.isEmpty) ||
        pass.isEmpty ||
        confirm.isEmpty) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Error',
        message: 'All fields are required.',
      );
      return;
    }

    // ✅ stricter: must be exactly 11 digits
    if (mobile.length != 11 || !RegExp(r'^\d{11}$').hasMatch(mobile)) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Error',
        message: 'Mobile number must be 11 digits.',
      );
      return;
    }

    // ✅ replace your old pass.length < 6 check
    if (!_isStrongPassword(pass)) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Error',
        message:
            'Password should be 8 characters, a mixture of letter and numbers consisting of at least one special character with Uppercase and Lowercase letters.',
      );
      return;
    }

    if (pass != confirm) {
      await CustomDialogs.showMessage(
        context: context,
        title: 'Error',
        message: 'Password and Confirm Password must match.',
      );
      return;
    }

    await CustomDialogs.showMessage(
      context: context,
      title: 'Success',
      message: 'Registration complete. You can now login.',
    );

    if (!mounted) return;
    Navigator.pop(context); // back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FB_PRIMARY,
      appBar: AppBar(
        backgroundColor: FB_PRIMARY,
        title: CustomFont(
          text: "Register",
          fontSize: 18.sp,
          color: FB_TEXT_COLOR_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _fnameCtrl,
              hintText: "First Name",
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 12.h),

            CustomTextFormField(
              controller: _lnameCtrl,
              hintText: "Last Name",
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 12.h),

            CustomTextFormField(
              controller: _mobileCtrl,
              hintText: "Mobile Number",
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
            ),
            SizedBox(height: 12.h),

            CustomTextFormField(
              controller: _userCtrl,
              hintText: "Username / Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
            ),
            SizedBox(height: 12.h),

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
            SizedBox(height: 12.h),

            CustomTextFormField(
              controller: _confirmCtrl,
              hintText: "Confirm Password",
              prefixIcon: Icons.lock,
              obscureText: _hideConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _hideConfirm ? Icons.visibility_off : Icons.visibility,
                  color: FB_TEXT_COLOR_GRAY,
                ),
                onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
              ),
            ),
            SizedBox(height: 18.h),

            CustomInkwellButton(buttonName: "Submit", onTap: _register),
            SizedBox(height: 12.h),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomFont(
                text: "Already have an account? Login here",
                fontSize: 14.sp,
                color: FB_LIGHT_PRIMARY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
