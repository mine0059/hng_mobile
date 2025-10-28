import 'package:flutter/material.dart';
import 'package:hng_mobile/model/quiz_answer.dart';
import 'package:hng_mobile/model/quiz_category.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.quizAnswers,
    required this.category,
  });

  final List<QuizAnswer> quizAnswers;
  final QuizCategory category;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Review'),
        backgroundColor: widget.category.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.category.color.withOpacity(0.1),
              widget.category.color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.quizAnswers.length,
          itemBuilder: (context, index) {
            final answer = widget.quizAnswers[index];
            return _buildQuestionReviewCard(answer, index);
          },
        ),
      ),
    );
  }

  Widget _buildQuestionReviewCard(QuizAnswer answer, int index) {
    final isUnanswered = answer.selectedAnswer == null;
    final cardColor = answer.isCorrect
        ? Colors.green.shade50
        : (isUnanswered ? Colors.grey.shade100 : Colors.red.shade50);
    final borderColor = answer.isCorrect
        ? Colors.green
        : (isUnanswered ? Colors.grey : Colors.red);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.category.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: borderColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUnanswered
                              ? Icons.access_time
                              : (answer.isCorrect
                                  ? Icons.check_circle
                                  : Icons.cancel),
                          color: borderColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isUnanswered
                              ? 'Unanswered'
                              : (answer.isCorrect ? 'Correct' : 'Incorrect'),
                          style: TextStyle(
                            color: borderColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Question Text
            Text(
              answer.questionText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d3748),
              ),
            ),
            const SizedBox(height: 16),
            // Options
            ...answer.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;
              final isCorrectOption = optionIndex == answer.correctAnswer;
              final isSelectedOption = optionIndex == answer.selectedAnswer;

              Color optionColor;
              IconData? optionIcon;
              Color? textColor;

              if (isCorrectOption) {
                optionColor = Colors.green;
                optionIcon = Icons.check_circle;
                textColor = Colors.white;
              } else if (isSelectedOption && !answer.isCorrect) {
                optionColor = Colors.red;
                optionIcon = Icons.cancel;
                textColor = Colors.white;
              } else {
                optionColor = Colors.grey.shade200;
                textColor = const Color(0xff2d3748);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrectOption || isSelectedOption
                      ? optionColor
                      : optionColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrectOption
                        ? Colors.green
                        : (isSelectedOption
                            ? Colors.red
                            : Colors.grey.shade300),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (optionIcon != null)
                      Icon(
                        optionIcon,
                        color: Colors.white,
                        size: 24,
                      ),
                  ],
                ),
              );
            }).toList(),
            // Explanation for unanswered
            if (isUnanswered)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Time ran out before you could answer',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
