import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxInput extends StatelessWidget {
  final TextEditingController? controllera;
  final IconData? globicon;
  final int? batas;
  final String? placeholder;
  final bool read;
  final EdgeInsets sp;
  const BoxInput(
      {super.key,
      required this.controllera,
      required this.sp,
      required this.globicon,
      required this.placeholder,
      required this.batas,
      required this.read,
      });

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
                color: Colors.grey.shade900, blurRadius: 15, offset: Offset(-4, -4)),
       
          ]),
          padding: const EdgeInsets.all(4.0),
      child: Center(
        child: TextField(
          scrollPadding: sp,
          readOnly: read,
          maxLength: batas,
          controller: controllera,
          style: const TextStyle(
            color: Color.fromRGBO(150, 150, 150, 1)
          ),
          decoration: InputDecoration(
            constraints: const BoxConstraints(
              minHeight: 30
            ),
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color.fromRGBO(80, 80, 80, 1)
              ),
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