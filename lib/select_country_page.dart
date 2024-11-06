import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final _auth = FirebaseAuth.instance;
  String _selectedCountry = 'France';
  String _username = ''; // Variable pour stocker le pseudo de l'utilisateur

  Future<void> _saveUserInfo() async {
    final user = _auth.currentUser;

    if (user != null && _username.isNotEmpty) {
      try {
        // Enregistrement du pays et du pseudo dans Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'country': _selectedCountry,
          'username': _username, // Sauvegarde du pseudo
        }, SetOptions(merge: true));

        // Redirection vers la page d'accueil après enregistrement
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print("Erreur lors de l'enregistrement des informations : $e");
      }
    } else {
      // Affiche un message si le pseudo est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un pseudo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Country"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose the country you want to represent:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue!;
                });
              },
              items: <String>['France', 'USA', 'Canada', 'Germany', 'Italy']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Champ de saisie pour le pseudo
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveUserInfo,
                child: Text("Save and Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7F3DFF),
                  minimumSize: Size(200, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
