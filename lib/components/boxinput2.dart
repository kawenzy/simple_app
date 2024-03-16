import 'package:flutter/material.dart';

class BoxInput2 extends StatelessWidget {
  final Function(String) func;
  final TextEditingController controllera;
  final String placeholder;
  final IconData globicon;
  const BoxInput2(
      {super.key,
      required this.controllera,
      required this.func,
      required this.globicon,
      required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromRGBO(23, 23, 23, 1),
          boxShadow: [
            const BoxShadow(
                color: Colors.black, blurRadius: 15, offset: Offset(4, 4)),
            BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 15,
                offset: Offset(-4, -4)),
          ]),
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: TextField(
          onChanged: func,
          controller: controllera,
          style: const TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          decoration: InputDecoration(
              constraints: const BoxConstraints(minHeight: 30),
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1)),
              counterText: '',
              prefixIcon: Icon(
                size: 26,
                globicon,
                color: const Color.fromRGBO(137, 137, 137, 1),
              )),
        ),
      ),
    );
  }
}
