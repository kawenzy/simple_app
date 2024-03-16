import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParamsAuth extends StatelessWidget {
  final String desc;
  final String url;
  final Widget function;
  const ParamsAuth({super.key, required this.desc, required this.url, required this.function});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(desc, style: GoogleFonts.montserrat(color: const Color.fromRGBO(150, 150, 150, 1),fontSize: 15, fontWeight: FontWeight.w500),),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => function));
            },
            child: Text(url, style: GoogleFonts.montserrat(color: const Color.fromARGB(255, 94, 70, 184),fontSize: 15, fontWeight: FontWeight.w500),),
          )
        ],
      ),
    );
  }
}