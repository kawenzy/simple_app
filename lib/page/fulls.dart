import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:penmetch/components/boxinput.dart';
import 'package:penmetch/components/chat.dart';
import 'package:penmetch/components/swp.dart';

class Fulls extends StatefulWidget {
  final String fullsId;
  const Fulls({super.key, required this.fullsId});

  @override
  State<Fulls> createState() => _FullsState();
}

class _FullsState extends State<Fulls> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> fullM = [];
  String? contentlike;
  final rdid = nanoid(length: 10);
  Map<String, bool> likeit = {};
  Map<String, dynamic>? like;
  final User? user = FirebaseAuth.instance.currentUser;
  String? likeUser;
  final TextEditingController _msg = TextEditingController();

  Future<List<Map<String, dynamic>>> getPostId() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('post')
        .where('idPost', isEqualTo: widget.fullsId)
        .get();
    return snapshot.docs.map((doc) {
      final posData = doc.data();
      final idPost = posData['idPost'];
      final content = posData['content'];
      final profile = posData['profile'];
      final title = posData['title'];
      final name = posData['name'];
      return {
        'idPost': idPost,
        'content': content,
        'profile': profile,
        'name': name,
        'title': title,
      };
    }).toList();
  }

  @override
  void initState() {
    getPostId().then((data) {
      setState(() {
        fullM = data;
      });
    });
    super.initState();
  }

  void getLike(String likeId) async {
    final likeDoc = _firestore.collection('like').doc('$likeId${user!.uid}');
    final likeSnapshot = await likeDoc.get();
    if (likeSnapshot.exists) {
      await likeDoc.delete();
    } else {
      try {
        await _firestore.collection('like').doc('$likeId${user!.uid}').set({
          'likecontent': likeUser,
          'idPost': contentlike,
        });
      } catch (error) {
        debugPrint('gagal like');
      }
    }
  }

  Future<Map<String, dynamic>> getPostIde() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('post').doc(widget.fullsId).get();
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
      final dataComment = await getPostIde();
      final rdid = nanoid(length: 10);
      final dataUser = await getUser();
      final idPost = dataComment['idPost'];
      final name = dataUser['name'];
      final profile = dataUser['profile'];
      await _firestore
          .collection('chatrooms')
          .doc(widget.fullsId)
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

  void download(String url, String name) async {
    FileDownloader.downloadFile(url: url, name: name);
    setState(() {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'user${user!.uid}',
              title: 'succes',
              body: 'download selesai'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Column(
                  children: fullM.map((posData) {
                    final idPost = posData['idPost'];
                    final content = posData['content'];
                    final profile = posData['profile'];
                    final name = posData['name'];
                    final title = posData['title'];
                    final isLiked = likeit[idPost] ?? false;
                    return Swp(
                      func2: () {
                        download(content, title);
                      },
                      title: title,
                      profile: NetworkImage(profile),
                      src: content,
                      name: name,
                      function: () {
                        setState(() {
                          likeUser = user!.uid;
                          contentlike = idPost;
                          // Toggle the like status for the post
                          if (likeit.containsKey(idPost)) {
                            likeit[idPost] = !likeit[idPost]!;
                          } else {
                            likeit[idPost] = true;
                          }
                        });
                        getLike(idPost);
                      },
                      love: Icon(
                        isLiked ? Ionicons.heart : Ionicons.heart_outline,
                        size: 30,
                        color: isLiked ? Colors.red : Colors.grey.shade200,
                      ),
                      cmnt: const Icon(
                        Ionicons.chatbubble_outline,
                        size: 28,
                        color: Color.fromRGBO(1, 1, 1, 0),
                      ),
                      function1: () {},
                    );
                  }).toList(),
                ),
              ],
            ),
            //disini bisa menggunakan expanded atau flexible dan flex 1 
            Expanded(
              child: SingleChildScrollView(
                reverse: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firestore
                        .collection('chatrooms')
                        .doc(widget.fullsId)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
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
      ),
    );
  }
}
