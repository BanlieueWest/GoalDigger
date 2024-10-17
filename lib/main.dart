import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import du package provider
import 'package:shared_preferences/shared_preferences.dart';  // Import du package shared_preferences
import 'settings.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'questions_solo.dart'; // Import de la page QuestionSolo

void main() {
  runApp(MyApp());
}

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Charger le thème depuis SharedPreferences
  ThemeNotifier() {
    _loadFromPrefs();
  }

  // Activer ou désactiver le mode sombre
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveToPrefs();
    notifyListeners();
  }

  // Sauvegarder le thème dans SharedPreferences
  Future<void> _saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
  }

  // Charger le thème depuis SharedPreferences
  Future<void> _loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // En-tête GoalDigger ajouté ici
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),  // Remplace 'SettingsPage' par ta page cible
                );
              },
            ),
            Text(
              'GoalDigger',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(width: 50),  // Pour équilibrer avec l'icône de gauche
          ],
        ),
      ),

      body: _pages[_selectedIndex], // Afficher la page sélectionnée

      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Page 2'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Page 3'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Page 4'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Page 5'),
        ],
      ),
    );
  }
}
