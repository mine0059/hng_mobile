import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../infrastructure/image_upload_controller.dart';

class ImagePreviewer extends StatelessWidget {
  const ImagePreviewer({
    super.key,
    required this.size,
    required this.pickedFile,
    required this.removeFile,
    required this.context,
    required this.completer,
    required this.setFile,
  });

  final Size size;
  final File? pickedFile;
  final Function removeFile;
  final BuildContext context;
  final Completer? completer;
  final Function setFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        image: DecorationImage(
          image: FileImage(File(pickedFile!.path)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: () {
                    ImageUploadController.showFilePickerButtomSheet(
                      context,
                      completer,
                      setFile,
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    removeFile();
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        'Remove',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
