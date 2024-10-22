import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Déconnexion de l'utilisateur
            await FirebaseAuth.instance.signOut();
            // Redirection vers la page de connexion
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: Text('Se déconnecter'),
        ),
      ),
    );
  }
}
