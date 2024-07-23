import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Theme/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  final Color startColor;
  final Color endColor;
  final double height;
  final double width;
  final double borderRadius;
  final Color btnTextColor;
  final double? fontSize;
  CustomButton({
    this.fontSize = 13,
    required this.buttonName,
    this.btnTextColor = Colors.black,
    this.onPressed,
    this.startColor = AppColor.buttonColor,
    this.endColor = AppColor.headingColor,
    this.height = 40.0,
    this.width = double.infinity,
    this.borderRadius = 20.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onPressed ??
            () {
              print('Button Pressed');
            },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [widget.startColor, widget.endColor],
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          height: widget.height,
          width: widget.width,
          child: Center(
            child: Text(
              widget.buttonName,
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: widget.btnTextColor,
                  fontSize: widget.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
