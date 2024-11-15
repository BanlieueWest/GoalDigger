import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuppressionComptePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _reAuthenticateAndDelete(BuildContext context) async {
    try {
      // Demande à l'utilisateur de saisir à nouveau son mot de passe
      String? password = await _askPassword(context);
      if (password == null) return; // L'utilisateur a annulé

      User? user = _auth.currentUser;
      if (user == null) return;

      // Crée les informations d'identification avec le mot de passe entré
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Réauthentifie l'utilisateur
      await user.reauthenticateWithCredential(credential);

      // Supprime les données de l'utilisateur dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // Supprime le compte de l'utilisateur
      await user.delete();

      // Redirige vers l'écran de connexion ou d'accueil après la suppression
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression du compte : $e'),
        ),
      );
    }
  }

  Future<String?> _askPassword(BuildContext context) async {
    String? password;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmez votre mot de passe'),
          content: TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Mot de passe'),
            onChanged: (value) {
              password = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Annule et ferme le dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(password); // Retourne le mot de passe
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supprimer mon compte'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _reAuthenticateAndDelete(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text('Supprimer mon compte'),
        ),
      ),
    );
  }
}
