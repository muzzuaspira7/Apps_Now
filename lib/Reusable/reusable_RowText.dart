import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowText extends StatefulWidget {
  final String content, title;
  const RowText({super.key, required this.content, required this.title});

  @override
  State<RowText> createState() => _RowTextState();
}

class _RowTextState extends State<RowText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 100,
          child: Text(
            '${widget.title}',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            width: 10,
            child: Text(
              ":  ",
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
            )),
        SizedBox(
            width: 150,
            child: Text(
              widget.content,
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
            ))
      ],
    );
  }
}
