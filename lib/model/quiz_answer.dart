class QuizAnswer {
  final int questionIndex;
  final int? selectedAnswer;
  final int correctAnswer;
  final bool isCorrect;
  final String questionText;
  final List<String> options;

  QuizAnswer({
    required this.questionIndex,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.questionText,
    required this.options,
  });
}
