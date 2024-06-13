import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../services/auth_provider.dart'; // Adjust the path as per your project structure

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final AuthProvider _authProvider = AuthProvider(); // Use AuthProvider instead of AuthService directly
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isTermsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sign up to',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Image(
                              image: AssetImage('assets/icons/pinkLogo.png'),
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFieldWithTitle(
                    title: 'Name',
                    hintText: 'Enter your name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWithTitle(
                    title: 'Username',
                    hintText: 'Enter your username',
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWithTitle(
                    title: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontVariations: [FontVariation('wght', 500)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(color: Color(0xFF999999)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffe6e6e6)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffe6e6e6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffe6e6e6)),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isTermsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsChecked = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'By signing up you agree to our Terms, Privacy Policy, and Cookie Use',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isTermsChecked
                        ? () async {
                            try {
                              await _authProvider.register(
                                _nameController.text,
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _isTermsChecked,
                              );

                              // Registration successful, now attempt login
                              await _authProvider.login(
                                _emailController.text,
                                _passwordController.text,
                              );

                              // Navigate to home or next screen after successful login
                              Provider.of<AuthProvider>(context, listen: false).updateUserDetails();
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                            } catch (e) {
                              // Handle registration or login failure
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Registration Failed: $e'),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFFD507E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontVariations: [FontVariation('wght', 500)]),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Color(0xFF808080),
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontVariations: [FontVariation('wght', 400)]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontVariations: [FontVariation('wght', 500)],
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;

  const TextFieldWithTitle({
    required this.title,
    required this.hintText,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontVariations: [FontVariation('wght', 500)],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffe6e6e6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffe6e6e6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffe6e6e6)),
            ),
          ),
        ),
      ],
    );
  }
}
