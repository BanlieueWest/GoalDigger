import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Text(
                "Hi, Welcome Back! 👋",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Please sign in to your account",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                label: 'Email',
                placeholder: 'example@gmail.com',
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
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Implémente la redirection vers la page "Forgot Password"
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _login,
                child: LoginButton(), // Utilisation de ton nouveau widget
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
                text: 'Login with Facebook',
                color: Colors.blue,
                onPressed: () {
                  // Implémente la connexion avec Facebook
                },
              ),
              SizedBox(height: 10),
              _buildSocialButton(
                text: 'Login with Google',
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Implémente la connexion avec Google
                },
              ),
              SizedBox(height: 20),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
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
            color: Colors.white.withOpacity(0.8),
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
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

// Ajout de ton widget LoginButton
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 312,
          height: 48,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 312,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFF0D63D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 134,
                top: 11,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
