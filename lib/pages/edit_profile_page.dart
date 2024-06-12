import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/profile.jpg'), // Add your image asset here
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
              _buildTextField(label: 'Username', controller: _usernameController),
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
                          // Handle save functionality here
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaveButtonEnabled
                        ? Color(0xffFD507E)
                        : Colors.grey,
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
