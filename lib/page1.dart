import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final _auth = FirebaseAuth.instance;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _username = userDoc.data()?['username'] ?? 'Utilisateur'; // Par défaut si pas de pseudo
      });
    }
  }

  void _navigateToDeleteAccount() {
    Navigator.of(context).pushNamed('/suppressionCompte');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1 - Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bonjour $_username!', // Affiche le pseudo de l'utilisateur
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/quizSolo');
              },
              child: Text('Jeu Solo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToDeleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Bouton rouge pour suppression
              ),
              child: Text('Supprimer mon compte'),
            ),
          ],
        ),
      ),
    );
  }
}
