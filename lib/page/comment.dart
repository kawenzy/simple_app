import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:penmetch/components/boxinput.dart';
import 'package:penmetch/components/chat.dart';

class Comment extends StatefulWidget {
  final String commentid;
  const Comment({super.key, required this.commentid});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController _msg = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getPostId() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('post').doc(widget.commentid).get();
    if (snapshot.exists) {
      final dataPost = snapshot.data() as Map<String, dynamic>;
      final idPost = dataPost['idPost'];
      return {
        'idPost': idPost,
      };
    } else {
      return {
        'idPost': null,
      };
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user!.uid).get();
    if (snapshot.exists) {
      final dataUSer = snapshot.data() as Map<String, dynamic>;
      final name = dataUSer['name'];
      final profile = dataUSer['profile'];
      return {'name': name, 'profile': profile};
    } else {
      return {'name': null, 'profile': null};
    }
  }

  Future<void> sendMsg() async {
    try {
      final dataComment = await getPostId();
      final rdid = nanoid(length: 10);
      final dataUser = await getUser();
      final idPost = dataComment['idPost'];
      final name = dataUser['name'];
      final profile = dataUser['profile'];
      await _firestore
          .collection('chatrooms')
          .doc(widget.commentid)
          .collection('chats')
          .doc(rdid)
          .set({
        'idPost': idPost,
        'sendBy': name,
        'idBy': user!.uid,
        'profile': profile,
        'msgs': _msg.text,
      });
      _msg.clear();
    } catch (error) {
      debugPrint('failed comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Ionicons.arrow_back,
              color: Colors.white,
              size: 26,
            ),
          ),
          backgroundColor: Color.fromRGBO(23, 23, 23, 1),
          title: Text(
            'comment',
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _firestore
                          .collection('post')
                          .doc(widget.commentid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          final posData = snapshot.data!;
                          final description = posData['description'];
                          return Container(
                            height: 30,
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  description,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade100),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
                          //disini bisa menggunakan expanded atau flexible dan flex 1 
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  reverse: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _firestore
                          .collection('chatrooms')
                          .doc(widget.commentid)
                          .collection('chats')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final postData = snapshot.data!.docs
                              .map((doc) => {...doc.data(), 'id': doc.id})
                              .toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: postData.map((post) {
                              final sendBy = post['sendBy'];
                              final profile = post['profile'];
                              final msg = post['msgs'];
                              return Chat(
                                profile: NetworkImage(profile),
                                description: msg,
                                name: sendBy,
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Stack(
                    children: [
                      BoxInput(
                          sp: const EdgeInsets.all(0),
                          controllera: _msg,
                          globicon: Ionicons.chatbubbles_outline,
                          placeholder: '.......',
                          batas: 30,
                          read: false),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.shade700,
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(4),
                                  topRight: Radius.circular(4))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: GestureDetector(
                            onTap: sendMsg,
                            child: Icon(
                              Icons.send,
                              color: Colors.grey.shade100,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
