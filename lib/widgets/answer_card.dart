import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  const AnswerCard(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.isCorrect,
      required this.isWrong,
      required this.onTap,
      required this.color});

  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;
  final Color color;

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get cardColor {
    if (widget.isCorrect) return Colors.green;
    if (widget.isWrong) return Colors.redAccent;
    if (widget.isSelected) return widget.color;
    return Colors.white;
  }

  Color get textColor {
    if (widget.isCorrect || widget.isWrong || widget.isSelected) {
      return Colors.white;
    }
    return const Color(0xff2d3748);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.isCorrect)
                  const Icon(
                    Icons.check,
                    size: 24,
                    color: Colors.white,
                  ),
                if (widget.isWrong)
                  const Icon(
                    Icons.cancel,
                    size: 24,
                    color: Colors.white,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
