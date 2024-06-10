import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';

class ShowArticlePage extends StatefulWidget {
  @override
  _ShowArticlePageState createState() => _ShowArticlePageState();
}

class _ShowArticlePageState extends State<ShowArticlePage> {
  int _selectedIndex = 1;
  /* bool _isLoggedIn = false; */  // Change this based on actual authentication status

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Article'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Power of Make Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '9 October 2023 • by Tasya Farasya',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/images/profile.jpg',  // Replace with the actual image path
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, elite consectetur adipiscing, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum. Lorem ipsum dolor sit amet, elite consectetur adipiscing, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum...',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Comment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              /* _isLoggedIn ? */ _buildCommentSection() /* : _buildLoginPrompt() */,
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

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        Text('You must be logged in to post a comment'),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Navigate to sign in page
              },
              child: Text('Sign in'),
            ),
            Text('or'),
            TextButton(
              onPressed: () {
                // Navigate to sign up page
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Write a comment ...',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Handle comment post
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildComment('Jessica22', 'Lorem ipsum dolor sit amet, elite consectetur adipiscing, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', '6h ago'),
        _buildComment('Rian.cool.guy', 'Lorem ipsum dolor sit amet, elite consectetur adipiscing, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', '6h ago'),
        _buildComment('TeddyBear', 'Lorem ipsum dolor sit amet, elite consectetur adipiscing, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', '6h ago'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Load more comments
          },
          child: Text('Show more'),
          style: ElevatedButton.styleFrom(
            backgroundColor : Colors.pink,
          ),
        ),
      ],
    );
  }

  Widget _buildComment(String username, String content, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            // Replace with actual user profile image if available
            child: Text(username[0]),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(content),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 12,
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
