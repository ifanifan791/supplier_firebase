import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../DashboardScreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String confirmPassword = ''; 
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Title
              Text(
                'Welcome to Registration',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20.0),

              // Email TextField
              _buildTextField(
                hintText: 'Enter your email',
                obscureText: false,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 12.0),

              // Password TextField
              _buildTextField(
                hintText: 'Enter your password',
                obscureText: true,
                onChanged: (value) => password = value,
              ),
              SizedBox(height: 12.0),

              // Confirm Password TextField
              _buildTextField(
                hintText: 'Confirm your password',
                obscureText: true,
                onChanged: (value) => confirmPassword = value,
              ),
              SizedBox(height: 24.0),

              // Register Button
              ElevatedButton(
                onPressed: () async {
                  if (password.length < 6) {
                    // Show an alert if the password is too short
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password must be at least 6 characters long!')),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    // If the passwords do not match, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match!')),
                    );
                    return;
                  }

                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (userCredential.user != null) {
                      // Navigate to home screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      );
                    }
                  } catch (e) {
                    print(e);
                    // Optionally, show an error message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create account. Please try again later.')),
                    );
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                ),
                child: showSpinner
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Register',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField widget to avoid repetition
  Widget _buildTextField({
    required String hintText,
    required bool obscureText,
    required Function(String) onChanged,
  }) {
    return TextField(
      obscureText: obscureText,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      style: TextStyle(fontSize: 16.0),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
    );
  }
}
