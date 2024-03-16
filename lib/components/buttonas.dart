import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonas extends StatelessWidget {
  final VoidCallback? function;
  final String title;
  const Buttonas({super.key, required this.function, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(25, 25, 25, 1),
                Color.fromRGBO(20, 20, 20, 1)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
                   BoxShadow(
                color: Colors.green.shade600,
                blurRadius: 0,
                offset: const Offset(1, 1)
              ),
              const BoxShadow(
                  color: Colors.black, blurRadius: 15, offset: Offset(4, 4)),
               BoxShadow(
                color: Colors.blueGrey.shade600,
                blurRadius: 0,
                offset: const Offset(-1, -1)
              ),
              BoxShadow(
                  color: Colors.grey.shade900,
                  blurRadius: 15,
                  offset: const Offset(-4, -4)),
            ]
            ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(195, 195, 195, 1)),
          ),
        ),
      ),
    );
  }
}