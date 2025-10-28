import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  AppUser? _user;
  AppUser? get user => _user;

  static const String _usersKey = 'local_users';
  static const String _loggedInKey = 'logged_in_user';

  AuthService() {
    _loadLoggedInUser();
  }

  Future<void> _loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_loggedInKey);
    if (json != null) {
      final m = jsonDecode(json);
      _user = AppUser.fromMap(Map<String, dynamic>.from(m));
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> _getAllUsersRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_usersKey);
    if (json == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  Future<bool> signup(String name, String email, String password) async {
    final users = await _getAllUsersRaw();
    final exists = users.any((u) => u['email'] == email);
    if (exists) return false;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    users.add({'id': id, 'name': name, 'email': email, 'password': password});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
    // auto-login
    final newUser = AppUser(id: id, name: name, email: email);
    _user = newUser;
    await prefs.setString(_loggedInKey, jsonEncode(newUser.toMap()));
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    final users = await _getAllUsersRaw();
    final found = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    if (found.isEmpty) return false;
    final user = AppUser(id: found['id'], name: found['name'], email: found['email']);
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInKey, jsonEncode(user.toMap()));
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    _user = null;
    notifyListeners();
  }
  
  // DEMO FALLBACK: Demo social sign-in *without* external packages.
  // This creates a demo user locally so the UI flow and navigation works.
  // Replace with real provider integration (google_sign_in / flutter_facebook_auth)
  // when you want production auth.
  Future<bool> signInWithGoogle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = 'google_${DateTime.now().millisecondsSinceEpoch}';
      final demo = AppUser(id: id, name: 'Google User', email: 'google.user@example.com');
      _user = demo;
      await prefs.setString(_loggedInKey, jsonEncode(demo.toMap()));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = 'facebook_${DateTime.now().millisecondsSinceEpoch}';
      final demo = AppUser(id: id, name: 'Facebook User', email: 'facebook.user@example.com');
      _user = demo;
      await prefs.setString(_loggedInKey, jsonEncode(demo.toMap()));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}


