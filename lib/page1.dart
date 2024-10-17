import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Profil et Statistiques
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_image.png'), // Placez l'image de profil ici
                      ),
                      Icon(Icons.camera_alt, size: 30),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "LaPTank 2 Feuille",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlagIcon('assets/france_flag.png'), // Image du drapeau
                      SizedBox(width: 10),
                      Text("RANG MONDIAL", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 20),
                      Text("20 679", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlagIcon('assets/france_flag.png'), // Image du drapeau
                      SizedBox(width: 10),
                      Text("RANG LOCAL", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 20),
                      Text("2 406", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Progress bar section
                  SizedBox(height: 20),
                  Text(
                    "PROCHAIN NIVEAU À ATTEINDRE",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ProgressBar(
                    currentProgress: 321003,
                    totalProgress: 321600,
                  ),
                ],
              ),
            ),
            // Boutons
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomButton(text: "JEU SOLO"),
                  SizedBox(height: 10),
                  CustomButton(text: "UN CONTRE UN"),
                  SizedBox(height: 10),
                  DailyChallengeButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour les icônes de drapeau
class FlagIcon extends StatelessWidget {
  final String imagePath;

  FlagIcon(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 30,
      height: 30,
    );
  }
}

// ProgressBar pour afficher la progression
class ProgressBar extends StatelessWidget {
  final int currentProgress;
  final int totalProgress;

  ProgressBar({required this.currentProgress, required this.totalProgress});

  @override
  Widget build(BuildContext context) {
    double progress = currentProgress / totalProgress;
    return Column(
      children: [
        Text(
          "$currentProgress / $totalProgress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.yellow[700],
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

// CustomButton pour les boutons "JEU SOLO" et "UN CONTRE UN"
class CustomButton extends StatelessWidget {
  final String text;

  CustomButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Remplace `primary` par `backgroundColor`
        foregroundColor: Colors.blue, // Remplace `onPrimary` par `foregroundColor`
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }
}

// DailyChallengeButton avec un Timer
class DailyChallengeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              "CHALLENGES QUOTIDIENS",
              style: TextStyle(fontSize: 18),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Remplace `primary` par `backgroundColor`
            foregroundColor: Colors.blue, // Remplace `onPrimary` par `foregroundColor`
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
        Positioned(
          right: 20,
          child: Row(
            children: [
              Icon(Icons.timer, color: Colors.yellow[700]),
              SizedBox(width: 5),
              Text(
                "18:57:26",
                style: TextStyle(fontSize: 16, color: Colors.yellow[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}