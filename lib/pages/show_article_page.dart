import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import 'dart:convert';
import '../../constant.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowArticlePage extends StatefulWidget {
  final int articleId;

  const ShowArticlePage({Key? key, required this.articleId}) : super(key: key);

  @override
  _ShowArticlePageState createState() => _ShowArticlePageState();
}

class _ShowArticlePageState extends State<ShowArticlePage> {
  late Map<String, dynamic> _articleData;
  int _selectedIndex = 0;
  bool _isLoading = true; // Add this variable
  bool _showAllComments = false; // Add this variable
  List<dynamic> _displayedComments = []; // List to store displayed comments

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchArticle();
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
        _isLoading = false; // Set isLoading to false even in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: CustomAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
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
          if (!_showAllComments &&
              allComments.length >
                  4) // Conditionally render the button only if there are more than 4 comments
            SizedBox(height: 16),
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
            // Replace with actual user profile image if available
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
}
