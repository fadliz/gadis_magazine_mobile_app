import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
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
              'Sign up to',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Q-Magazine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
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
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    // Handle checkbox
                  },
                ),
                Expanded(
                  child: Text(
                    'By signing up you agree to our Terms, Privacy Policy, and Cookie Use',
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle register
              },
              child: Text('Create an Account'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.grey,
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
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Sign In', style: TextStyle(color: Colors.pink)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}