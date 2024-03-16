import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penmetch/components/boxinput.dart';
import 'package:penmetch/components/buttonas.dart';
import 'package:penmetch/components/buttup.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _titlec = TextEditingController();
  final TextEditingController _descc = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final rdid = nanoid(length: 20);
  File? _thumb;
  String? _thumburl;
  String errmsg = 'failed upload';
  String succmsg = 'succes upload your content';

 

  Future<void> getThumb() async {
    final pick = ImagePicker();
    final pickIMg = await pick.pickImage(source: ImageSource.gallery);
    if (pickIMg != null) {
      final extension = path.extension(pickIMg.path);
      final fileName = '$rdid$extension';
      setState(() {
        _thumb = File(pickIMg.path);
        _thumburl = fileName;
      });
    }
  }


  Future<Map<String, dynamic>> getUser() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user!.uid).get();
    if (userDoc.exists) {
      final DataUser = userDoc.data() as Map<String, dynamic>;
      final name = DataUser['name'];
      final profile = DataUser['profile'];
      return {'name': name, 'profile': profile};
    } else {
      print('alamak');
      return {'name': null, 'profile': null};
    }
  }

  Future<void> upload() async {
    try {
      final DataUser = await getUser();
      final nameUser = DataUser['name'];
      final profileUser = DataUser['profile'];
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'user${user!.uid}',
              title: 'succes',
              body: succmsg));
      if (user != null) {
          if(_thumb != null) {
            Reference storageref = _storage.ref('post/$_thumburl');
            UploadTask uploadTask = storageref.putFile(_thumb!);
            await uploadTask.whenComplete(() => null);
            _thumburl = await storageref.getDownloadURL();
          }
      }
      await _firestore.collection('post').doc(rdid).set({
        'title': _titlec.text,
        'content': _thumburl,
        'description': _descc.text,
        'profile': profileUser,
        'name': nameUser,
        'idPost': rdid,
        'idUser': user!.uid
      });
      _descc.clear();
      _titlec.clear();
    } catch (error) {
      setState(() {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 1,
                channelKey: 'user${user!.uid}',
                title: 'failed',
                body: errmsg));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _thumb != null
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(23, 23, 23, 1),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              const BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 15,
                                  offset: Offset(4, 4)),
                              BoxShadow(
                                  color: Colors.grey.shade900,
                                  blurRadius: 15,
                                  offset: const Offset(-4, -4)),
                            ]),
                        child: ClipRect(
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(_thumb!),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 25,
                      ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'content',
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
                  child: GestureDetector(
                      onTap: getThumb,
                      child: const Buttup(data: 'upload file')),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BoxInput(
                    sp: const EdgeInsets.all(0),
                    controllera: _titlec,
                    globicon: Icons.title,
                    placeholder: 'name your content...',
                    batas: 100,
                    read: false,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BoxInput(
                    sp: const EdgeInsets.all(0),
                    controllera: _descc,
                    globicon: Icons.description,
                    placeholder: 'description your content...',
                    batas: 100,
                    read: false,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Buttonas(function: upload, title: 'submit'),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}