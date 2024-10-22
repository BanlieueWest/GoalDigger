import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Page1 extends StatelessWidget {
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
              'Bienvenue sur la Page 1',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Déconnexion de l'utilisateur
                await FirebaseAuth.instance.signOut();
                // Redirection vers la page de connexion
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
