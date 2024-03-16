import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:penmetch/components/ebar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:penmetch/components/swp.dart';
import 'package:penmetch/page/comment.dart';
import 'package:penmetch/page/setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? like;
  Map<String, dynamic>? commentMAP;
  String? likeUser;
  Map<String, bool> likeit = {};
  final rdid = nanoid(length: 10);
  String? contentlike;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUSer() async {
    DocumentSnapshot<Map<String, dynamic>> post =
        await _firestore.collection('users').doc(user?.uid).get();
    if (post.exists) {
      final datauser = post.data()!;
      final name = datauser['name'];
      final profile = datauser['profile'];
      return {
        'name': name,
        'profile': profile,
      };
    } else {
      return {
        'name': null,
        'profile': null,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getPost() async {
    final q = await _firestore.collection('post').get();
    final data = q.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    return data;
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

  void getComment(String commentid) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Comment(commentid: commentid)));
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: getUSer(),
                builder: (context, snapshot) {
                  if (user != null && snapshot.data != null) {
                    final data = snapshot.data!;
                    final namUser = data['name'];
                    return Ebar(
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Setting()));
                        },
                        nameUser: namUser);
                  } else {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Widget placeholder saat user masih null
                  }
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('post').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final postData = snapshot.data!.docs
                      .map((doc) => {
                            ...doc.data(),
                            'id': doc.id,
                          })
                      .toList();
                  return Column(
                    children: postData.map((post) {
                      final name = post['name'];
                      final profile = post['profile'];
                      final content = post['content'];
                      final title = post['title'];
                      final idPost = post['idPost'];
                      final isLiked = likeit[idPost] ?? false;
                      return Swp(
                        func2: () {
                          download(content, title);
                        },
                        function1: () {
                          getComment(idPost);
                        },
                        cmnt: Icon(Ionicons.chatbubble_outline, size: 28, color:Colors.grey.shade200,),
                        love: Icon(isLiked ? Ionicons.heart : Ionicons.heart_outline ,
                          size: 30,
                          color: isLiked ? Colors.red : Colors.grey.shade200,
                        ),
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
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: Text('No data'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}



          //  FutureBuilder<List<Map<String, dynamic>>>(
          //     future: getPost(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Container();
          //       } else if (snapshot.hasData) {
          //         final postData = snapshot.data!;
          //         postData.shuffle();
          //         return Column(
          //           children: postData.map((post) {
          //             final name = post['name'];
          //             final profile = post['profile'];
          //             final content = post['content'];
          //             final title = post['title'];
          //             final idPost = post['idPost'];
          //             final isLiked = likeit[idPost] ?? false;
          //             return Swp(
          //                 love: Icon(
          //                   Ionicons.heart,
          //                   size: 30,
          //                   color: isLiked ? Colors.red : Colors.grey.shade200,
          //                 ),
          //                 title: title,
          //                 profile: NetworkImage(profile),
          //                 src: content,
          //                 name: name,
          //                 function: () {
          //                   setState(() {
          //                     likeUser = user!.uid;
          //                     contentlike = idPost;
          //                     // Toggle the like status for the post
          //                     if (likeit.containsKey(idPost)) {
          //                       likeit[idPost] = !likeit[idPost]!;
          //                     } else {
          //                       likeit[idPost] = true;
          //                     }
          //                   });
          //                   getLike(idPost);
          //                 });
          //           }).toList(),
          //         );
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text('Error: ${snapshot.error}'));
          //       } else {
          //         return const Center(child: Text('No data'));
          //       }
          //     },
          //   ),