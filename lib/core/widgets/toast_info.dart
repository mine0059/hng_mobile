import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hng_mobile/core/constants/app_color.dart';
import 'package:hng_mobile/core/constants/enums/status.dart';

void toastInfo({
  required String msg,
  required Status status,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: status == Status.success
        ? AppColors.primaryColor
        : AppColors.errorColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
