import 'package:flutter/material.dart';
import 'package:goaldigger2/signup.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'profile.dart';
import 'login.dart'; // Ajout de la page de connexion
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Routes pour rediriger entre la page principale et la page de connexion
      routes: {
        '/home': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(), // Assure-toi que la page signup e
      },
      home: AuthWrapper(), // Vérifie si l'utilisateur est connecté
    );
  }
}

// Widget pour vérifier l'état d'authentification
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return MainPage(); // Rediriger vers la page principale si l'utilisateur est connecté
        } else {
          return LoginPage(); // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
        }
      },
    );
  }
}

// Page principale de l'application
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  // Récupère l'utilisateur actuellement connecté
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonProfilPage()),
                );
              },
              child: Icon(Icons.settings, color: Colors.white),
            ),
            Text(
              'Goal Digger',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 24),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Text(
            currentUser != null
                ? 'Connecté en tant que : ${currentUser!.email ?? "Inconnu"}'
                : 'Non connecté',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
    );
  }
}
