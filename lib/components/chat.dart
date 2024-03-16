import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatelessWidget {
  final ImageProvider profile;
  final String name;
  final String description;
  const Chat(
      {super.key,
      required this.profile,
      required this.description,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: profile,
                radius: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(120, 120, 120, 1)),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    description,
                    style: GoogleFonts.notoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(220, 220, 220, 1)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
