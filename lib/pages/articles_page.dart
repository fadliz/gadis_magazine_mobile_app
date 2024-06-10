import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Articles'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 5,  // Replace with the actual number of articles
          itemBuilder: (context, index) {
            return ArticleCard();
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/profile.jpg',  // Replace with the actual image path
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BEAUTY',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The Power of Make Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, elite consectetur adipiscing ams da sakaske bajerl eiusmod...',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'by Tasya Farasya',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
