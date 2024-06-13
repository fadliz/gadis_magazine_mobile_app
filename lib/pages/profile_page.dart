import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../services/auth_provider.dart';
import '../constant.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthProvider _authProvider = AuthProvider();
  int _selectedIndex = 2;
  bool isLoggedIn = false; // Initially, the user is not logged in

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await _authProvider.checkAuth();
    setState(() {
      isLoggedIn = _authProvider.isAuthenticated;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
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
                _authProvider.logout();
                setState(() {
                  isLoggedIn = false;
                });
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
        child: isLoggedIn ? _buildProfile() : _buildSignInSignUp(),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildProfile() {
    final user = _authProvider.user['user'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user['picture'] != null
                  ? NetworkImage('${baseURL}/storage/${user['picture']}')
                  : AssetImage('assets/icons/placeholder_image.png'),
              // Replace with user's avatar
            ),
            title: Text(
              user['name'] ?? 'Name not available',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontVariations: [FontVariation('wght', 600)],
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '@${user['username']}',
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
                leading: const Icon(Icons.person_outline, color: Colors.pink),
                title: const Text(
                  'My Account',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 500)],
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Make changes to your account',
                  style: TextStyle(
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
                onTap: () => _navigateToPage(context, EditProfilePage(user: _authProvider.user['user'])),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Log out',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 500)],
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                subtitle: const Text(
                  'Further secure your account for safety',
                  style: TextStyle(
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
    );
  }

  Widget _buildSignInSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.blue),
                title: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 500)],
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                subtitle: const Text(
                  'Create a new account',
                  style: TextStyle(
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
                onTap: () => _navigateToPage(context, RegisterPage()),
              ),
              ListTile(
                leading: const Icon(Icons.login, color: Colors.green),
                title: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontVariations: [FontVariation('wght', 500)],
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                subtitle: const Text(
                  'Already have an account? Sign in',
                  style: TextStyle(
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
                onTap: () => _navigateToPage(context, LoginPage()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
