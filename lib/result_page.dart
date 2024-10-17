import 'package:flutter/material.dart';
import 'dart:math'; // Pour dessiner le demi-cercle
import 'questions_solo.dart'; // Import de la page du quiz

class ResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final bool hasLost;
  final List<Map<String, dynamic>> questions; // Liste des questions

  ResultPage({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.hasLost,
    required this.questions, // Passe la liste des questions
  });

  @override
  Widget build(BuildContext context) {
    double percentage = correctAnswers / totalQuestions;
    Color themeColor = hasLost ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Demi-cercle avec le pourcentage de bonnes réponses
          CustomPaint(
            size: Size(200, 100), // Taille pour le demi-cercle
            painter: ArcPainter(percentage, themeColor),
          ),
          SizedBox(height: 20),
          Text(
            hasLost ? 'Défaite' : 'Victoire',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '${(percentage * 100).toInt()}% de bonnes réponses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Text(
            '$correctAnswers sur $totalQuestions correctes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuestionSolo()), // Relance le quiz
              );
            },
            child: Text('Recommencer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Couleur du bouton
              foregroundColor: themeColor, // Couleur du texte
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCorrectAnswersList(), // Liste des bonnes réponses
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour construire la liste défilante des bonnes réponses
  Widget _buildCorrectAnswersList() {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final correctAnswer = question['correctOption'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                question['question'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Bonne réponse: $correctAnswer',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArcPainter extends CustomPainter {
  final double percentage;
  final Color color;

  ArcPainter(this.percentage, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Couleur du contour du cercle
    Paint borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.4) // Couleur du contour avec un peu de transparence
      ..strokeWidth = 24 // Légèrement plus large que l'arc principal
      ..style = PaintingStyle.stroke;

    // Arc principal
    Paint arcPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 20 // Taille de l'arc
      ..style = PaintingStyle.stroke;

    double startAngle = pi; // Demi-cercle, commence à pi (180°)
    double sweepAngle = pi * percentage; // Balayage en fonction du pourcentage

    // Dessine le contour d'abord
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.width / 2),
      pi,
      pi, // Dessine tout le demi-cercle comme contour
      false,
      borderPaint,
    );

    // Ensuite, dessine l'arc principal
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.width / 2),
      startAngle,
      sweepAngle, // Balayage en fonction du pourcentage
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
