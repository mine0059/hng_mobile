import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hng_mobile/model/question.dart';
import 'package:hng_mobile/model/quiz_answer.dart';
import 'package:hng_mobile/model/quiz_category.dart';
import 'package:hng_mobile/screens/result_screen.dart';

import '../widgets/answer_card.dart';

class ActualQuizScreen extends StatefulWidget {
  const ActualQuizScreen({super.key, required this.category});

  final QuizCategory category;

  @override
  State<ActualQuizScreen> createState() => _ActualQuizScreenState();
}

class _ActualQuizScreenState extends State<ActualQuizScreen>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  late AnimationController _questionController;
  late AnimationController _timerController;
  Timer? _questionTimer;
  int timeLeft = 30; // 30 seconds per question
  List<QuizAnswer> quizAnswers = [];

  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    // Get questions from the category
    questions = widget.category.questions;

    _questionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _questionController.forward();
    startTimer();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _timerController.dispose();
    _questionTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timeLeft = 30;
    _timerController.reset();
    _timerController.forward();

    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          // Time's up - mark as unanswered and move to next
          if (!isAnswered) {
            _handleTimeout();
          }
        }
      });
    });
  }

  void _handleTimeout() {
    // Record unanswered question
    quizAnswers.add(QuizAnswer(
      questionIndex: currentQuestionIndex,
      selectedAnswer: null,
      correctAnswer: questions[currentQuestionIndex].correctAnswer,
      isCorrect: false,
      questionText: questions[currentQuestionIndex].text,
      options: questions[currentQuestionIndex].options,
    ));

    setState(() {
      isAnswered = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        nextQuestion();
      }
    });
  }

  void _selectedAnswer(int answerIndex) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answerIndex;
      isAnswered = true;
    });

    _questionTimer?.cancel();
    HapticFeedback.lightImpact();

    final isCorrect =
        answerIndex == questions[currentQuestionIndex].correctAnswer;
    if (isCorrect) {
      score++;
    }

    // Record the answer
    quizAnswers.add(QuizAnswer(
      questionIndex: currentQuestionIndex,
      selectedAnswer: answerIndex,
      correctAnswer: questions[currentQuestionIndex].correctAnswer,
      isCorrect: isCorrect,
      questionText: questions[currentQuestionIndex].text,
      options: questions[currentQuestionIndex].options,
    ));

    // Future.delayed(const Duration(milliseconds: 1500), () {
    //   if (mounted) {
    //     nextQuestion();
    //   }
    // });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _questionController.reset();
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
      _questionController.forward();
      startTimer();
    } else {
      // Navigate to result screen
      _questionTimer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            category: widget.category,
            quizAnswers: quizAnswers,
          ),
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      _questionController.reset();
      _questionTimer?.cancel();

      setState(() {
        currentQuestionIndex--;
        // Load previous answer if exists
        final previousAnswer = quizAnswers.firstWhere(
          (ans) => ans.questionIndex == currentQuestionIndex,
          orElse: () => QuizAnswer(
            questionIndex: currentQuestionIndex,
            selectedAnswer: null,
            correctAnswer: questions[currentQuestionIndex].correctAnswer,
            isCorrect: false,
            questionText: questions[currentQuestionIndex].text,
            options: questions[currentQuestionIndex].options,
          ),
        );
        selectedAnswer = previousAnswer.selectedAnswer;
        isAnswered =
            previousAnswer.selectedAnswer != null || !previousAnswer.isCorrect;
      });

      _questionController.forward();
      if (!isAnswered) {
        startTimer();
      }
    }
  }

  Color _getTimerColor() {
    if (timeLeft > 20) return Colors.green;
    if (timeLeft > 10) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              widget.category.color.withOpacity(0.1),
              widget.category.color.withOpacity(0.05),
            ])),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Color(0xff2d3748),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            (currentQuestionIndex + 1) / questions.length,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.category.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${currentQuestionIndex + 1}/${questions.length}",
                    style: const TextStyle(
                      color: Color(0xff2d3748),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _questionController,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ]),
                  child: Text(
                    question.text,
                    style: const TextStyle(
                        color: Color(0xff2d3748),
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (!isAnswered)
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: timeLeft / 30,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(_getTimerColor()),
                        ),
                      ),
                      Text(
                        '$timeLeft',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getTimerColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _questionController,
                      child: AnswerCard(
                        text: question.options[index],
                        isSelected: selectedAnswer == index,
                        isCorrect:
                            isAnswered && index == question.correctAnswer,
                        isWrong: isAnswered &&
                            index != question.correctAnswer &&
                            selectedAnswer == index,
                        onTap: () => _selectedAnswer(index),
                        color: widget.category.color,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentQuestionIndex > 0)
                    OutlinedButton(
                      onPressed: previousQuestion,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff2d3748),
                        side: BorderSide(color: widget.category.color),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  if (isAnswered)
                    ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.category.color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(currentQuestionIndex == questions.length - 1
                          ? 'Submit'
                          : 'Next'),
                    ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
