import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class UploadContainer extends StatelessWidget {
  const UploadContainer({
    super.key,
    required this.size,
    required this.title,
  });

  final Size size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.primaryColor,
      radius: const Radius.circular(15),
      strokeWidth: 1,
      child: SizedBox(
        height: size.height * 0.13,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.litePrimary,
              ),
              child: const Padding(
                padding: EdgeInsets.all(13.0),
                child: Icon(
                  Icons.document_scanner_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: 'Click to select ',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                ),
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: Color(0xff555555),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
