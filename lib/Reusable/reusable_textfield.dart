import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Theme/app_colors.dart';

class ReusableTextField extends StatefulWidget {
  final String hintText;
  final String header;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool isNumeric;
  final String? defaultValue;
  final double height;

  const ReusableTextField({
    Key? key,
    required this.hintText,
    this.height = 49.0,
    required this.header,
    required this.controller,
    this.inputFormatters,
    this.isNumeric = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      widget.controller.text = widget.defaultValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.header,
          style: GoogleFonts.openSans(
            color: AppColor.headingColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: 280,
          child: Form(
            key: _formKey,
            child: TextFormField(
              autocorrect: true,
              controller: widget.controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.backgroundColor,
                hintText: widget.hintText,
                hintStyle: GoogleFonts.openSans(
                  color: AppColor.primaryColor,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                isDense: true, 
              ),
              style: GoogleFonts.openSans(color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the details ${widget.hintText.toLowerCase()}';
                }
                return null;
              },
              inputFormatters: widget.inputFormatters,
              keyboardType:
                  widget.isNumeric ? TextInputType.number : TextInputType.text,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
