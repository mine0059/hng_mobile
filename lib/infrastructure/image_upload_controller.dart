import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hng_mobile/core/constants/app_color.dart';
import 'package:hng_mobile/core/shared/image_picket_helper.dart';
// import 'package:image_cropper/image_cropper.dart';

import '../core/constants/enums/record_source.dart';
import '../core/widgets/image_picker_component.dart';

class ImageUploadController {
  /// Pick image from camera and gallery
  static void imagePicker(
    RecordSource recordSource,
    Completer? completer,
    BuildContext context,
    Function setFile,
  ) async {
    if (recordSource == RecordSource.gallery) {
      final pickedFile = await ImagePicketHelper.pickImageFromGallery();
      if (pickedFile == null) {
        return;
      }
      completer?.complete(pickedFile.path);
      if (!context.mounted) {
        return;
      }
      setFile(pickedFile);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else if (recordSource == RecordSource.camera) {
      final pickedFile = await ImagePicketHelper.takePictureFromCamera();
      if (pickedFile == null) {
        return;
      }

      completer?.complete(pickedFile.path);
      if (!context.mounted) {
        return;
      }
      setFile(pickedFile);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// modal for selecting file source
  static Future showFilePickerButtomSheet(
    BuildContext context,
    Completer? completer,
    Function setFile,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 14, 15, 20),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  padding: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xffE4E4E4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Select Image Source',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ImagePickerTile(
                        title: 'Capture from Camera',
                        subtitle: 'Take a live snapshot',
                        icon: Icons.camera_alt_outlined,
                        recordSource: RecordSource.camera,
                        completer: completer,
                        context: context,
                        setFile: setFile,
                      ),
                      const Divider(color: Color(0xffE4E4E4)),
                      ImagePickerTile(
                        title: 'Upload from Gallery',
                        subtitle: 'Select image from gallery',
                        icon: Icons.image_outlined,
                        recordSource: RecordSource.gallery,
                        completer: completer,
                        context: context,
                        setFile: setFile,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
//   @override
//   (int, int)? get data => (2, 3);

//   @override
//   String get name => '2x3 (customized)';
// }
