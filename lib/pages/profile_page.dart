import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content:
              const Text('Are you sure you want to logout from your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle logout functionality here
              },
              child: const Text('Log out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: const CustomAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/profile.jpg'), // Add your image asset here
                ),
                title: Text(
                  'Lorem Ipsum',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 600)],
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '@Lorem',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 400)],
                    fontSize: 14,
                    color: Color(0xffb4b4b4),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading:
                        const Icon(Icons.person_outline, color: Colors.pink),
                    title: const Text(
                      'My Account',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 500)],
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      'Make changes to your account',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 400)],
                        fontSize: 12,
                        color: Color(0xffb4b4b4),
                      ),
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 16),
                    ),
                    onTap: _navigateToEditProfile,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Log out',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 500)],
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: const Text(
                      'Further secure your account for safety',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontVariations: [FontVariation('wght', 400)],
                        fontSize: 12,
                        color: Color(0xffb4b4b4),
                      ),
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 16),
                    ),
                    onTap: _showLogoutDialog,
                  ),
                ],
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
