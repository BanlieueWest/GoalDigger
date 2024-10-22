import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  String _username = '';
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  Future<void> _signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      Navigator.of(context).pushReplacementNamed('/home'); // Rediriger vers la page principale
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text(
              "Create an account",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Connect with your friends today!",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            _buildTextField(
              label: 'Username',
              placeholder: 'Enter Your Username',
              obscureText: false,
              onChanged: (value) {
                _username = value;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Email',
              placeholder: 'Enter Your Email',
              obscureText: false,
              onChanged: (value) {
                _email = value;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              placeholder: 'Enter Your Password',
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            Text(
              "Or With",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            _buildSocialButton(
              text: 'Signup with Facebook',
              color: Colors.blue,
              icon: Icons.facebook, // Utilisation de l'icône Facebook
              onPressed: () {
                // Implémente la connexion avec Facebook
              },
            ),
            SizedBox(height: 10),
            _buildGoogleButton(
              text: 'Signup with Google',
              color: Colors.white,
              textColor: Colors.black,
              imagePath: 'assets/images/google_logo.png', // Chemin de l'image Google
              onPressed: () {
                // Implémente la connexion avec Google
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/login');
              },
              child: Text(
                "Already have an account? Login",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String placeholder,
    required bool obscureText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 315,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(text, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: textColor == Colors.black ? Colors.grey : Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton({
    required String text,
    required Color color,
    Color textColor = Colors.black,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 24,
            ),
            SizedBox(width: 10),
            Text(text, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
