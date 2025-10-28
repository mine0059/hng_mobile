import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hng_mobile/core/constants/enums/record_source.dart';

import '../../infrastructure/image_upload_controller.dart';
import '../constants/app_color.dart';

class ImagePickerTile extends StatelessWidget {
  const ImagePickerTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.recordSource,
    required this.completer,
    required this.context,
    required this.setFile,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final RecordSource recordSource;
  final Completer? completer;
  final BuildContext context;
  final Function setFile;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.litePrimary,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 20,
        color: Color(0xffE4E4E4),
      ),
      onTap: () {
        ImageUploadController.imagePicker(
          recordSource,
          completer,
          context,
          setFile,
        );
      },
    );
  }
}
