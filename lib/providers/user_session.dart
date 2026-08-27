import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserSession extends ChangeNotifier {
  User? _user;
  String _identifier = '';

  User? get user => _user;
  String get identifier => _identifier;

  String get profileDisplayName {
    if (_user != null) {
      return _user!.fullName.isNotEmpty ? _user!.fullName : _user!.username;
    }

    final id = _identifier.trim();
    if (id.isEmpty) return 'Guest';
    if (id.contains('@')) return id.split('@').first;
    return id;
  }

  bool get isLoggedIn => _user != null || _identifier.isNotEmpty;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString('logged_in_user');

    if (rawUser == null || rawUser.isEmpty) {
      _user = null;
      _identifier = '';
      notifyListeners();
      return;
    }

    try {
      final decoded = jsonDecode(rawUser);
      _user = User.fromJson(Map<String, dynamic>.from(decoded as Map));
      _identifier = _user!.username;
    } catch (_) {
      _user = null;
      _identifier = '';
    }

    notifyListeners();
  }

  Future<void> login(
    String usernameOrEmail, {
    String? password,
    User? user,
  }) async {
    if (user != null) {
      _user = user;
      _identifier = user.username;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user', jsonEncode(user.toJson()));
      notifyListeners();
      return;
    }

    _identifier = usernameOrEmail.trim();
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _identifier = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user');
    notifyListeners();
  }
}
