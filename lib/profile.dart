import 'package:flutter/material.dart';

class MonProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page de Mon Profil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
