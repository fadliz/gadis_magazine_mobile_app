import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String username,
    String email,
    String password,
    bool tos,
  ) async {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'tos': tos,
      }),
    );
      debugPrint(jsonEncode(response.statusCode));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    final token = await storage.read(key: 'token');
    await http.post(
      Uri.parse(logoutURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    await storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse(profileURL), // Replace with your user details URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}
