import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'result_page.dart';

class QuestionSolo extends StatefulWidget {
  @override
  _QuestionSoloState createState() => _QuestionSoloState();
}

class _QuestionSoloState extends State<QuestionSolo> {
  double _progressValue = 1.0;
  int _remainingTime = 10;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  List<Color> _progressBarColors = [];
  bool _hasAnswered = false;
  List<Map<String, dynamic>> _answeredQuestions = [];
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  String? _selectedOption;
  bool _isAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _getQuestionsFromFirestore();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progressValue = _remainingTime / 10.0;
        } else {
          _registerAnswer(isCorrect: false);
        }
      });
    });
  }

  Future<void> _getQuestionsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('minijeu')
          .doc('minijeu1')
          .collection('questions')
          .get();

      List<Map<String, dynamic>> loadedQuestions = snapshot.docs.map((doc) {
        return {
          'question': doc['question'],
          'options': List<String>.from(doc['options']),
          'correctOption': doc['correctAnswer'],
          'icon': Icons.question_answer,
        };
      }).toList();

      loadedQuestions.shuffle();
      loadedQuestions = loadedQuestions.take(10).toList();

      setState(() {
        _questions = loadedQuestions;
        _isLoading = false;
        startTimer();
      });
    } catch (e) {
      print('Erreur lors du chargement des questions : $e');
    }
  }

  void _goToNextQuestion() {
    _timer?.cancel();
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _remainingTime = 10;
        _progressValue = 1.0;
        _hasAnswered = false;
        _selectedOption = null;
        _isAnswerCorrect = false;
        startTimer();
      });
    } else {
      _navigateToResultPage();
    }
  }

  void _registerAnswer({required bool isCorrect}) {
    setState(() {
      _hasAnswered = true;
      _isAnswerCorrect = isCorrect;

      _progressBarColors.add(isCorrect ? Colors.green : Colors.red);

      _answeredQuestions.add(_questions[_currentQuestionIndex]);

      if (isCorrect) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
        if (_incorrectAnswers >= 3) {
          _navigateToResultPage();
        }
      }

      if (_incorrectAnswers < 3) {
        Future.delayed(Duration(seconds: 2), _goToNextQuestion);
      }
    });
  }

  void _answerQuestion(String selectedOption) {
    if (_hasAnswered) return;

    setState(() {
      _selectedOption = selectedOption;
    });

    bool isCorrect = selectedOption == _questions[_currentQuestionIndex]['correctOption'];
    _registerAnswer(isCorrect: isCorrect);
  }

  void _navigateToResultPage() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalQuestions: _questions.length,
          correctAnswers: _correctAnswers,
          hasLost: _incorrectAnswers >= 3,
          questions: _answeredQuestions,
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF9F7EFF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final correctOption = currentQuestion['correctOption'];

    return Scaffold(
      backgroundColor: Color(0xFF9F7EFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xFF7646FD),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: _progressValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8F51),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
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
            Container(
              width: 327,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFB084),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        currentQuestion['icon'],
                        size: 64,
                        color: Color(0xFF280A82),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  AutoSizeText(
                    currentQuestion['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF280A82),
                    ),
                    maxLines: 3,
                    minFontSize: 14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            for (String option in currentQuestion['options'])
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildAnswerButton(context, option, correctOption),
              ),
            SizedBox(height: 20),
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
                          : Colors.grey.withOpacity(0.2),
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

  Widget _buildAnswerButton(BuildContext context, String text, String correctOption) {
    bool isCorrect = text == correctOption;
    bool isSelected = _selectedOption != null && text == _selectedOption;

    Color buttonColor;
    if (_hasAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red;
      } else if (isCorrect) {
        buttonColor = Colors.green;
      } else {
        buttonColor = Colors.transparent;
      }
    } else {
      buttonColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: () => _answerQuestion(text),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 2,
          ),
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
