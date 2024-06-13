import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  Map<String, dynamic> _user = {};

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic> get user => _user;

  Future<void> checkAuth() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      _isAuthenticated = true;
      _user = await _authService
          .getUserDetails(); // Fetch user details from backend
      _user['token'] = token;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      final token = response['access_token'];
      await _storage.write(key: 'token', value: token);
      _isAuthenticated = true;
      _user = await _authService
          .getUserDetails(); // Fetch user details from backend
      _user['token'] = token;
      debugPrint(jsonEncode(_user));
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      rethrow;
    }
  }

  Future<void> register(String name, String username, String email,
      String password, bool tos) async {
    try {
      final response =
          await _authService.register(name, username, email, password, tos);
      final token = response['access_token'];
      await _storage.write(key: 'token', value: token);
      _isAuthenticated = true;
      _user = await _authService
          .getUserDetails(); // Fetch user details from backend
      _user['token'] = token;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await _storage.delete(key: 'token');
    _isAuthenticated = false;
    _user = {};
    notifyListeners();
  }

  // Update user details after profile update
  Future<void> updateUserDetails() async {
    // Update _user with updated details
    _user = await _authService.getUserDetails();
    if (_user.isNotEmpty) {
      _isAuthenticated = true;
    }
    // If there are more fields to update, add them similarly

    notifyListeners();
  }
}
