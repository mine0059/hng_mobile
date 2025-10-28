import 'package:flutter/material.dart';
import 'package:hng_mobile/model/question.dart';

class QuizCategory {
  QuizCategory({
    required this.name,
    required this.icon,
    required this.description,
    required this.questionCount,
    required this.color,
    required this.questions,
  });

  final String name;
  final IconData icon;
  final String description;
  final int questionCount;
  final Color color;
  final List<Question> questions;
}
