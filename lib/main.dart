import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/articles_page.dart';
import 'pages/show_article_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Magazine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/article',
      routes: {
        '/': (context) => const LandingPage(),
        '/articles': (context) => const ArticlesPage(),
        '/article': (context) => const ShowArticlePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
