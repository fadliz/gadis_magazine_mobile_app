import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign in to',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Q-Magazine',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink),
            ),
            SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle reset password
                },
                child: Text('Reset your password',
                    style: TextStyle(color: Colors.pink)),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle login
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor:
                    Colors.grey, // Use backgroundColor instead of primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.pink)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
