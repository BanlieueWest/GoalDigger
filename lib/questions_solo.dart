import 'package:flutter/material.dart';
import 'dart:async';
import 'result_page.dart'; // Import de la page des résultats

class QuestionSolo extends StatefulWidget {
  @override
  _QuestionSoloState createState() => _QuestionSoloState();
}

class _QuestionSoloState extends State<QuestionSolo> {
  double _progressValue = 1.0; // Commence à 100%
  int _remainingTime = 10; // 10 secondes pour répondre
  Timer? _timer;
  int _currentQuestionIndex = 0; // Index de la question actuelle
  int _correctAnswers = 0; // Compteur des bonnes réponses
  int _incorrectAnswers = 0; // Compteur des mauvaises réponses
  List<Color> _progressBarColors = []; // Stocke les couleurs (vert pour bonne réponse, rouge pour mauvaise)
  bool _hasAnswered = false; // Pour savoir si l'utilisateur a répondu à la question
  List<Map<String, dynamic>> _answeredQuestions = []; // Liste des questions répondues (correct ou incorrect)

  // Liste des 10 questions avec 4 propositions de réponses
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is\nthis thing?',
      'options': ['Book', 'Pencil', 'Eraser', 'Ruler'],
      'correctOption': 'Pencil',
      'icon': Icons.create, // Icône associée à la question
    },
    {
      'question': 'What is\nthis object?',
      'options': ['Phone', 'Laptop', 'Tablet', 'Monitor'],
      'correctOption': 'Laptop',
      'icon': Icons.laptop, // Icône pour une autre question
    },
    {
      'question': 'Find the\ncorrect answer',
      'options': ['Car', 'Bicycle', 'Motorcycle', 'Truck'],
      'correctOption': 'Bicycle',
      'icon': Icons.pedal_bike,
    },
    {
      'question': 'What can you\nuse to write?',
      'options': ['Eraser', 'Pen', 'Keyboard', 'Monitor'],
      'correctOption': 'Pen',
      'icon': Icons.edit,
    },
    {
      'question': 'Which of these\nis an animal?',
      'options': ['Tree', 'Dog', 'Car', 'House'],
      'correctOption': 'Dog',
      'icon': Icons.pets,
    },
    {
      'question': 'What is\nthis thing?',
      'options': ['Keyboard', 'Mouse', 'Monitor', 'Table'],
      'correctOption': 'Mouse',
      'icon': Icons.mouse,
    },
    {
      'question': 'Which one is\na color?',
      'options': ['Red', 'Dog', 'Car', 'House'],
      'correctOption': 'Red',
      'icon': Icons.color_lens,
    },
    {
      'question': 'What do you\nuse to sit?',
      'options': ['Chair', 'Dog', 'Tree', 'House'],
      'correctOption': 'Chair',
      'icon': Icons.chair,
    },
    {
      'question': 'Which one is\nan insect?',
      'options': ['Butterfly', 'Car', 'House', 'Monitor'],
      'correctOption': 'Butterfly',
      'icon': Icons.bug_report,
    },
    {
      'question': 'What is\nthis device?',
      'options': ['Smartphone', 'Bicycle', 'Car', 'House'],
      'correctOption': 'Smartphone',
      'icon': Icons.phone_iphone,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Fonction pour démarrer le timer de 10 secondes
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progressValue = _remainingTime / 10.0;
        } else {
          _registerAnswer(isCorrect: false); // Enregistre une réponse fausse si l'utilisateur n'a pas répondu
        }
      });
    });
  }

  // Fonction pour passer à la question suivante
  void _goToNextQuestion() {
    _timer?.cancel(); // Annule le timer actuel
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _remainingTime = 10; // Réinitialise le temps
        _progressValue = 1.0; // Réinitialise la progression
        _hasAnswered = false; // L'utilisateur n'a pas encore répondu à cette nouvelle question
        startTimer(); // Redémarre le timer pour la question suivante
      });
    } else {
      // Toutes les questions sont terminées, on redirige vers la page des résultats
      _navigateToResultPage();
    }
  }

  // Fonction pour enregistrer une réponse
  void _registerAnswer({required bool isCorrect}) {
    setState(() {
      _hasAnswered = true;
      _progressBarColors.add(isCorrect ? Colors.green : Colors.red);

      // Ajoute la question actuelle aux questions répondues
      _answeredQuestions.add(_questions[_currentQuestionIndex]);

      if (isCorrect) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
        if (_incorrectAnswers >= 3) {
          _navigateToResultPage(); // Rediriger si 3 mauvaises réponses sont atteintes
        }
      }

      // Après une courte pause, passe à la question suivante ou à la page de résultat
      if (_incorrectAnswers < 3) {
        Future.delayed(Duration(seconds: 1), _goToNextQuestion);
      }
    });
  }

  // Quand l'utilisateur sélectionne une option, cette fonction est appelée
  void _answerQuestion(String selectedOption) {
    if (_hasAnswered) return; // Si l'utilisateur a déjà répondu, ne fait rien

    bool isCorrect = selectedOption == _questions[_currentQuestionIndex]['correctOption'];
    _registerAnswer(isCorrect: isCorrect);
  }

  // Rediriger vers la page de résultats avec les questions répondues
  void _navigateToResultPage() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalQuestions: _questions.length,
          correctAnswers: _correctAnswers,
          hasLost: _incorrectAnswers >= 3, // Indique si l'utilisateur a perdu
          questions: _answeredQuestions, // Passe uniquement les questions répondues
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Color(0xFF9F7EFF), // Fond dégradé violet
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _timer?.cancel(); // Annule le timer si on quitte
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        centerTitle: true,
        title: Text(
          "Question ${_currentQuestionIndex + 1}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barre de progression pour le timer
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xFF7646FD), // Couleur de fond de la barre
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: _progressValue, // Proportion de temps écoulé
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8F51), // Couleur de progression du timer
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                // Timer affiché
                Text(
                  '$_remainingTime s',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Image et Question avec carré blanc
            Container(
              width: 327, // Largeur pour s'ajuster à l'écran
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  // Image de l'objet
                  Container(
                    width: 150,
                    height: 150, // Ajuster la taille de l'image
                    decoration: BoxDecoration(
                      color: Color(0xFFFFB084),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        currentQuestion['icon'], // Icône dynamique pour chaque question
                        size: 64,
                        color: Color(0xFF280A82),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Texte de la question
                  Text(
                    currentQuestion['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF280A82),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Affichage des options de réponse (4 options)
            for (String option in currentQuestion['options'])
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildAnswerButton(context, option),
              ),

            SizedBox(height: 20),

            // Barre de progression des réponses (rouge pour mauvaise, vert pour bonne)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _questions.length,
                    (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 10,
                    decoration: BoxDecoration(
                      color: index < _progressBarColors.length
                          ? _progressBarColors[index]
                          : Colors.grey.withOpacity(0.2), // Gris si pas encore répondu
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construction des boutons de réponse
  Widget _buildAnswerButton(BuildContext context, String text) {
    bool isSelected = _hasAnswered && text == _questions[_currentQuestionIndex]['correctOption'];

    return GestureDetector(
      onTap: () => _answerQuestion(text), // Réagir au clic
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF8F51) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Color(0x663510A5),
              blurRadius: 32,
              offset: Offset(0, 16),
            )
          ]
              : [
            BoxShadow(
              color: Color(0x4C572FFF),
              blurRadius: 20,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
