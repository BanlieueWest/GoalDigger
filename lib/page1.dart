import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart'; // Import GetWidget package
import 'dart:async';
import 'package:intl/intl.dart'; // Import intl for date and timezone manipulation
import 'questions_solo.dart'; // Import de la page QuestionSolo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF70B7F4), // Fond bleu
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Profil et Statistiques
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // Avatar, Nom et Édition
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GFAvatar(
                                radius: 50,
                                backgroundImage:
                                AssetImage('assets/profile_image.png'), // Replace with your asset
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GFIconButton(
                                  icon: Icon(Icons.camera_alt, color: Colors.white),
                                  onPressed: () {
                                    // Handle photo change
                                  },
                                  shape: GFIconButtonShape.circle,
                                  size: GFSize.SMALL,
                                  color: GFColors.PRIMARY,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      SizedBox(width: 10), // Espacement
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LaPTank 2 Feuille",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          GFIconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Handle edit action
                            },
                            shape: GFIconButtonShape.pills,
                            size: GFSize.SMALL,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Rank Section Mondial/Local
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRankColumn('assets/france_flag.png', "RANG MONDIAL", "20 679"),
                      _buildRankColumn('assets/france_flag.png', "RANG LOCAL", "2 406"),
                    ],
                  ),

                  // Section de la barre de progression
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 30),
                            SizedBox(width: 5),
                            Text(
                              "PROCHAIN NIVEAU À ATTEINDRE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        ProgressBar(
                          currentProgress: 321003,
                          totalProgress: 321600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Boutons JEU SOLO, UN CONTRE UN, CHALLENGE QUOTIDIEN
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bouton JEU SOLO qui redirige vers QuestionSolo
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

  // Widget pour afficher le rang (Rang mondial/local)
  Widget _buildRankColumn(String flagPath, String label, String value) {
    return Column(
      children: [
        Image.asset(
          flagPath,
          width: 30,
          height: 30,
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

// ProgressBar pour afficher la progression avec GetWidget GFProgressBar
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 5),
        GFProgressBar(
          percentage: progress, // Proportion de progression
          backgroundColor: Colors.black26, // Couleur de fond
          progressBarColor: Colors.yellow[700] ?? Colors.yellow, // Couleur de la barre
          lineHeight: 10, // Hauteur de la barre
          radius: 10, // Bords arrondis
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
    return GFButton(
      onPressed: () {
        if (text == "JEU SOLO") {
          // Redirige vers la page questions_solo.dart
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionSolo()), // Page QuestionSolo
          );
        }
        // Ajoutez d'autres actions pour d'autres boutons si nécessaire
      },
      text: text,
      shape: GFButtonShape.pills,
      color: GFColors.PRIMARY,
      textColor: Colors.blue,
      elevation: 5,
      size: GFSize.LARGE,
      blockButton: true, // Pour un bouton large
    );
  }
}

// DailyChallengeButton avec un Timer qui se reset à minuit (fuseau horaire de Paris)
class DailyChallengeButton extends StatefulWidget {
  @override
  _DailyChallengeButtonState createState() => _DailyChallengeButtonState();
}

class _DailyChallengeButtonState extends State<DailyChallengeButton> {
  late Timer _timer;
  Duration _duration = Duration();

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilMidnight(); // Calculate the time until midnight Paris
    _startTimer();
  }

  void _calculateTimeUntilMidnight() {
    final now = DateTime.now().toUtc(); // Current time in UTC
    final parisTimezoneOffset = Duration(hours: 2); // CET/CEST (Paris time UTC+2 during DST)

    // Convert to Paris time
    final parisNow = now.add(parisTimezoneOffset);

    // Calculate the next midnight in Paris time
    final nextMidnight = DateTime(parisNow.year, parisNow.month, parisNow.day + 1);

    // Set the duration until midnight
    _duration = nextMidnight.difference(parisNow);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = _duration - Duration(seconds: 1);
        } else {
          _timer.cancel();
          _calculateTimeUntilMidnight(); // Reset the timer for the next day
          _startTimer(); // Restart the timer
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GFButton(
          onPressed: () {},
          text: "CHALLENGES QUOTIDIENS",
          shape: GFButtonShape.pills,
          color: GFColors.SECONDARY,
          textColor: Colors.blue,
          elevation: 5,
          size: GFSize.LARGE,
          blockButton: true,
        ),
        Positioned(
          right: 20,
          child: Row(
            children: [
              Icon(Icons.timer, color: Colors.yellow[700]),
              SizedBox(width: 5),
              Text(
                _formatDuration(_duration),
                style: TextStyle(fontSize: 16, color: Colors.yellow[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
