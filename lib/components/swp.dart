import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Swp extends StatelessWidget {
  final String title;
  final String src;
  final VoidCallback function;
  final String name;
  final Widget love;
  final ImageProvider profile;
  final VoidCallback function1;
  final VoidCallback func2;
  final Widget cmnt;
  const Swp({
    super.key,
    required this.title,
    required this.profile,
    required this.src,
    required this.name,
    required this.function,
    required this.love,
    required this.cmnt,
    required this.function1,
    required this.func2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRect(
            child: AspectRatio(
                aspectRatio: 1 / 1,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: GestureDetector(
                      onDoubleTap: func2,
                      child: Image.network(
                        src,
                        filterQuality: FilterQuality.medium,
                      ),
                    )))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: profile,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.notoSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(190, 190, 190, 1)),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(120, 120, 120, 1)),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(onTap: function1, child: cmnt),
                  const SizedBox(width: 10,),
                  GestureDetector(onTap: function, child: love),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
