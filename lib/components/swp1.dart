import 'package:flutter/material.dart';

class Swp1 extends StatelessWidget {
  final VoidCallback func;
  final String src;
  const Swp1({Key? key, required this.src, required this.func});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: func,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  src,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}