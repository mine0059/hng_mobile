// ignore_for_file: public_member_api_docs, sort_constructors_first
class Question {
  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  final String text;
  final List<String> options;
  final int correctAnswer;
}
