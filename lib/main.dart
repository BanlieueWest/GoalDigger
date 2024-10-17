import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  // Liste des pages de l'application
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  // Méthode pour gérer le changement de page sans recréer la page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.settings, color: Colors.white),
              Text('Goal Digger', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 24), // Pour équilibrer avec l'icône de gauche
            ],
          ),
        ),
        body: _pages[_selectedIndex], // Affiche la page sélectionnée
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // L'index de la page actuelle
          onTap: _onItemTapped, // Méthode appelée lors de la sélection
          type: BottomNavigationBarType.fixed, // Pour éviter les animations sur les labels
          selectedItemColor: Colors.blue, // Couleur de l'élément actif
          unselectedItemColor: Colors.grey, // Couleur des éléments non sélectionnés
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Page 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Page 3',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Page 4',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Page 5',
            ),
          ],
        ),
      ),
    );
  }
}
