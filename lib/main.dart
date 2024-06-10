import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/articles_page.dart';
import 'pages/show_article_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Magazine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/article',
      routes: {
        '/': (context) => LandingPage(),
        '/articles': (context) => ArticlesPage(),
        '/article': (context) => ShowArticlePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
