import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typewritertext/typewritertext.dart';

class Ebar extends StatelessWidget {
  final VoidCallback function;
  final String nameUser;
  const Ebar({super.key, required this.function, required this.nameUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromRGBO(23, 23, 23, 1),
          boxShadow: [
            BoxShadow(
                color: Colors.indigo.shade600,
                blurRadius: 0,
                offset: const Offset(1, 1)),
            const BoxShadow(
                color: Colors.black, blurRadius: 15, offset: Offset(4, 4)),
            BoxShadow(
                color: Colors.blueGrey.shade600,
                blurRadius: 0,
                offset: const Offset(-1, -1)),
            BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 15,
                offset: const Offset(-4, -4)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TypeWriter.text(
            nameUser,
            duration: const Duration(milliseconds: 500),
            repeat: true,
            style: GoogleFonts.notoSans(
                color: const Color.fromRGBO(180, 180, 180, 1),
                fontSize: 22,
                fontWeight: FontWeight.w400),
          ),
          GestureDetector(
            onTap: function,
            child: const Icon(
              Icons.settings,
              size: 22,
              color: Color.fromRGBO(100, 100, 100, 1),
            ),
          )
        ],
      ),
    );
  }
}