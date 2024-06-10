import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Q-Magazine'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Something...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Top 3 Most View Article',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.network('https://via.placeholder.com/150'),
                      title: Text('The Power of Make Up'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BEAUTY',
                            style: TextStyle(color: Colors.pink),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lorem ipsum dolor sit amet, elit consectetur adipiscing ams da sakaske bajelr eiusmod...',
                          ),
                          SizedBox(height: 4),
                          Text(
                            'by Tasya Farasya',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle see all
              },
              child: Text('See All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pink,
                side: BorderSide(color: Colors.pink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}