import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/share/custom_text.dart';

SnackBar CustomSnack(errorMsg) {
  return SnackBar(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    margin: EdgeInsets.only(bottom: 30, right: 20, left: 20),
    elevation: 10,
    clipBehavior: Clip.none,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade900,
    content: Row(
      children: [
        Icon(CupertinoIcons.info, color: Colors.white),
        Gap(14),
        CustomText(
          text: errorMsg,
          color: Colors.white,
          size: 12,
          weight: FontWeight.w600,
        ),
      ],
    ),
  );
}
