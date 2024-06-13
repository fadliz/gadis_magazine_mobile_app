import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import 'dart:convert';
import '../../constant.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/auth_provider.dart'; // Import your AuthProvider
import 'login_page.dart'; // Import the login page
import 'register_page.dart'; // Import the register page
import 'package:flutter/gestures.dart'; // Import the register page
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShowArticlePage extends StatefulWidget {
  final int articleId;

  const ShowArticlePage({Key? key, required this.articleId}) : super(key: key);

  @override
  _ShowArticlePageState createState() => _ShowArticlePageState();
}

class _ShowArticlePageState extends State<ShowArticlePage> {
  late Map<String, dynamic> _articleData;
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _showAllComments = false;
  List<dynamic> _displayedComments = [];
  final AuthProvider _authProvider =
      AuthProvider(); // Add AuthProvider instance
  bool isLoggedIn = false; // Initially, the user is not logged in

  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Check authentication status
    _fetchArticle();
  }

  Future<void> _checkAuthentication() async {
    await _authProvider.checkAuth();
    setState(() {
      isLoggedIn = _authProvider.isAuthenticated;
    });
  }

  Future<void> _fetchArticle() async {
    final response =
        await http.get(Uri.parse('${articlesURL}/${widget.articleId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _articleData = data['article'];
        _isLoading = false;
      });
    } else {
      // Handle error
      print('Failed to fetch article');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) return;
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    Map<String, dynamic> updatedData = {
      'content': _commentController.text.trim(),
      'user_id': _authProvider.user['user']['id'],
      // Add more fields as needed
    };

    final response = await http.post(
      Uri.parse('${articlesURL}/${widget.articleId}/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${token}', // Assuming you have a token in AuthProvider
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 201) {
      // Add the new comment to the comments list
      setState(() {
        _articleData['comments'].add(jsonDecode(response.body));
        _commentController.clear();
      });
    } else {
      // Handle error
      print('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: CustomAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _articleData['title'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('MMM d, y').format(DateTime.parse(_articleData['created_at']))} • by ${_articleData['author']}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 400)],
                        fontSize: 12,
                        color: Color(0xfffd507e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      '${baseURL}/storage/${_articleData['image']}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _articleData['content'] ?? '',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 400)],
                        fontSize: 12,
                        color: Color(0xff6a6a6a),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Comment',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontVariations: [FontVariation('wght', 700)],
                        fontSize: 18,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    if (isLoggedIn)
                      _buildCommentInput(), // Add comment input if logged in
                    _buildCommentSection(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCommentSection() {
    if (!isLoggedIn) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                      text: 'You must be logged in to post a comment\nPlease '),
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                  ),
                  TextSpan(text: ' or '),
                  TextSpan(
                    text: 'Sign up now!',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    }

    if (_articleData.containsKey('comments')) {
      final List<dynamic> allComments = _articleData['comments'];
      _displayedComments =
          _showAllComments ? allComments : allComments.take(4).toList();

      return Column(
        children: [
          for (var comment in _displayedComments)
            _buildComment(
              comment['user']['username'],
              comment['content'],
              comment['created_at'],
            ),
          if (!_showAllComments && allComments.length > 4) SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 193,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAllComments = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xfffd507e),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Color(0xfffd507e)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Show More'),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildComment(String username, String content, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(
              username[0],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 400)],
                    fontSize: 12,
                    color: Color(0xff6a6a6a),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      timeago.format(DateTime.parse(time), locale: 'en'),
                      style: const TextStyle(
                        color: Color(0xffb4b4b4),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Write a Comment...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xffb4b4b4)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Color(0xFFB4B4B4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFB4B4B4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xFFB4B4B4)),
            ),
            suffixIcon: IconButton(
              icon: SvgPicture.asset('assets/icons/74120.svg'),
              onPressed: _submitComment,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
