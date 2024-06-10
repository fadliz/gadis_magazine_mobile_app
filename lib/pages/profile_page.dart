import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out'),
          content: Text('Are you sure you want to logout from your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle logout functionality here
              },
              child: Text('Log out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.jpg'), // Add your image asset here
              ),
              title: Text('Lorem Ipsum'),
              subtitle: Text('@Lorem'),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.pink),
              title: Text('My Account'),
              subtitle: Text('Make changes to your account'),
              onTap: _navigateToEditProfile,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Log out', style: TextStyle(color: Colors.red)),
              subtitle: Text('Further secure your account for safety'),
              onTap: _showLogoutDialog,
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
