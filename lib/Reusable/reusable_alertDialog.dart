import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_colors.dart';
import 'reusable_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      content: Text(content),
      actions: [
        CustomButton(
          buttonName: cancelText,
          width: 60,
          height: 30,
          startColor: AppColor.PurebackgroundColor,
          endColor: AppColor.backgroundColor,
          onPressed: onCancel,
        ),
        CustomButton(
          buttonName: confirmText,
          width: 60,
          height: 30,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
