import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:google_fonts/google_fonts.dart';
import 'package:penmetch/auth/login.dart';
import 'package:penmetch/components/boxinput.dart';
import 'package:penmetch/components/buttonas.dart';
import 'package:penmetch/components/paramsauth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _namec = TextEditingController();
  final TextEditingController _emailc = TextEditingController();
  final TextEditingController _passwordc = TextEditingController();
  final String _default = "assets/profile/default.png";
  final AssetImage _image = const AssetImage("assets/profile/default.png");
  File? _profile;
  String? _pfurl;
  String errMsg = 'failed register';
  String succMsg = 'verification your account in gmail';
  bool isVerificationSucces = false;

  Future<void> getImg() async {
    final pick = ImagePicker();
    final rdid = nanoid(length: 10);
    final pickImg = await pick.pickImage(source: ImageSource.gallery);
    if (pickImg != null) {
      final fileExt = path.extension(pickImg.path);
      final fileNm = "$rdid$fileExt";
      setState(() {
        _profile = File(pickImg.path);
        _pfurl = fileNm;
      });
    }
  }

  Future<void> register() async {
    try {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'register_channel',
              backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
              title: 'register for user',
              body: succMsg,
              color: const Color.fromRGBO(190, 190, 190, 1)));
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailc.text, password: _passwordc.text);
      if (userCredential.user != null) {
        if (_profile != null) {
          setState(() {
            isVerificationSucces = true;
          });
          await userCredential.user!.sendEmailVerification();
          Reference storageref = _storage.ref('profile/$_pfurl');
          UploadTask uploadTask = storageref.putFile(_profile!);
          await uploadTask.whenComplete(() => null);
          _pfurl = await storageref.getDownloadURL();
        }
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _namec.text,
          'email': _emailc.text,
          'password': _passwordc.text,
          'profile': _pfurl ?? _image,
          'uid': userCredential.user!.uid,
        });
        _namec.clear();
        _emailc.clear();
        _passwordc.clear();
        _profile ?? _default;
        _pfurl = '';
      }
    } catch (error) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'register_channel',
              backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
              title: 'register for user',
              body: errMsg,
              color: const Color.fromRGBO(190, 190, 190, 1)));
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
                Center(
                  child: GestureDetector(
                    onTap: getImg,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _profile != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: FileImage(
                                  _profile!,
                                  scale: 1,
                                ),
                              )
                            : CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(_default),
                              ),
                        Positioned(
                            bottom: 8,
                            right: 10,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(23, 23, 23, 1),
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: Color.fromRGBO(180, 180, 180, 1),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Register',
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
                    placeholder: 'your name..',
                    controllera: _namec,
                    globicon: Icons.people,
                    batas: 10,
                    read: false,
                  ),
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
                      globicon: Icons.email,
                      read: false,
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
                  child: Buttonas(function: register, title: 'submit'),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ParamsAuth(
                      desc: 'sudah punya akun?',
                      url: ' login',
                      function: Login()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
