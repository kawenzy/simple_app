import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:penmetch/components/boxinput2.dart';
import 'package:penmetch/components/swp1.dart';
import 'package:penmetch/page/fulls.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _search = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> result = [];
  List<Map<String, dynamic>> results = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getPost() async {
    final q = await _firestore.collection('post').get();
    final data = q.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    return data;
  }

  Future<void> serchPost() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('post')
        .where('title', isEqualTo: _search.text)
        .get();

    final List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final content = data['content'];
      final idPost = data['idPost'];
      return {'content': content, 'idPost': idPost};
    }).toList();
    setState(() {
      result = results;
    });
  }

  Future<List<Map<String, dynamic>>> getData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('post').get();
    return snapshot.docs.map((doc) {
      final posData = doc.data();
      final idPost = posData['idPost'];
      final content = posData['content'];
      return {'idPost': idPost, 'content': content};
    }).toList();
  }

  @override
  void initState() {
    getData().then((data) {
      setState(() {
        results = data;
      });
    });
    super.initState();
  }
  
  void getF(String fullsId) async{
    showBarModalBottomSheet(expand: true,backgroundColor: const Color.fromRGBO(23, 23, 23, 1),context: context, builder: (context) => Fulls(fullsId: fullsId),);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: BoxInput2(
                controllera: _search,
                func: (p0) => serchPost(),
                globicon: Icons.search,
                placeholder: '....',
              ),
            ),
            result.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(25),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 180),
                      itemCount: result.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final dataPost = result[index];
                        return Swp1(src: dataPost['content'],func: (){getF(dataPost['idPost']);},);
                      },
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(25),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 180,
                      ),
                      itemCount: results.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final dataPost = results[index];
                        return Swp1(src: dataPost['content'],func: (){getF(dataPost['idPost']);},);
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
