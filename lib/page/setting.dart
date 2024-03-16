import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penmetch/auth/register.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register(),));
            });
          },
          child: Text('logout', style: GoogleFonts.poppins(color: Colors.red.shade500, fontSize: 26, fontWeight: FontWeight.w600),),
        ),
      ),
    );
  }
}