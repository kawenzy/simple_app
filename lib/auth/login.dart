import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penmetch/auth/register.dart';
import 'package:penmetch/components/boxinput.dart';
import 'package:penmetch/components/buttonas.dart';
import 'package:penmetch/components/paramsauth.dart';
import 'package:penmetch/layouts/layouts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailc = TextEditingController();
  final TextEditingController _passwordc = TextEditingController();

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailc.text, password: _passwordc.text);
      if (userCredential.user != null) {
        _emailc.clear();
        _passwordc.clear();
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Layouts()));
        });
      }
    } catch (error) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: "register_channel",
              title: 'error',
              body: 'failed account'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                      color: const Color.fromRGBO(180, 180, 180, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BoxInput(
                      sp: const EdgeInsets.all(0),
                      placeholder: 'your email..',
                      controllera: _emailc,
                      read: false,
                      globicon: Icons.email,
                      batas: 100),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BoxInput(
                      sp: const EdgeInsets.all(0),
                      placeholder: 'your password..',
                      controllera: _passwordc,
                      globicon: Icons.password,
                      read: false,
                      batas: 8),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Buttonas(function: login, title: 'submit'),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ParamsAuth(
                      desc: 'belum punya akun?',
                      url: ' register',
                      function: Register()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
