import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttup extends StatelessWidget {
  final String data;
  const Buttup({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 23, 23, 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
            const BoxShadow(
                color: Colors.black, blurRadius: 15, offset: Offset(4, 4)),
            BoxShadow(
                color: Colors.grey.shade900, blurRadius: 15, offset: const Offset(-4, -4)),
       
          ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(data, style: GoogleFonts.poppins(
        color: const Color.fromRGBO(180, 180, 180, 1),
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),),
    );
  }
}