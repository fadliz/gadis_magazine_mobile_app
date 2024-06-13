import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedIndex = 2;
  bool _isSaveButtonEnabled = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkIfEmpty);
    _emailController.addListener(_checkIfEmpty);
    _nameController.addListener(_checkIfEmpty);
    _passwordController.addListener(_checkIfEmpty);
    _usernameController.text = widget.user['username'] ?? '';
    _emailController.text = widget.user['email'] ?? '';
    _nameController.text = widget.user['name'] ?? '';
  }

  void _checkIfEmpty() {
    setState(() {
      _isSaveButtonEnabled = _usernameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _nameController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _usernameController.removeListener(_checkIfEmpty);
    _emailController.removeListener(_checkIfEmpty);
    _nameController.removeListener(_checkIfEmpty);
    _passwordController.removeListener(_checkIfEmpty);

    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xffe6e6e6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xffe6e6e6)),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save'),
          content: const Text('Are you sure you want save these changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveProfile();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _saveProfile() async {
    // Construct the request body with updated user data
    Map<String, dynamic> updatedData = {
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'name': _nameController.text.trim(),
      // Add more fields as needed
    };
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    debugPrint(token);
    debugPrint(_usernameController.text.trim());

    try {
      final response = await http.post(
        Uri.parse('$profileURL/process'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Add any necessary headers
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        // Optionally update local user data or handle navigation
      } else {
        // Handle other response codes or errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } catch (e) {
      // Handle network or server errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: const CustomAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: user['picture'] != null
                          ? NetworkImage(
                              '${baseURL}/storage/${user['picture']}')
                          : AssetImage(
                              'assets/icons/placeholder_image.png'), // Add your image asset here
                      radius: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle edit picture functionality here
                      },
                      child: const Text(
                        'Edit picture',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontVariations: [FontVariation('wght', 600)],
                            color: Color(0xfffd507e)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  label: 'Username', controller: _usernameController),
              const SizedBox(height: 16),
              _buildTextField(label: 'Email', controller: _emailController),
              const SizedBox(height: 16),
              _buildTextField(label: 'Name', controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          _showConfirmDialog();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSaveButtonEnabled ? Color(0xffFD507E) : Colors.grey,
                    foregroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 170.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontVariations: [FontVariation('wght', 500)],
                        color: Colors.white),
                  ),
                ),
              ),
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
}
