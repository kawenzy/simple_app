import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? results;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user!.uid).get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final name = data['name'];
      final profile = data['profile'];
      return {'name': name, 'profile': profile};
    } else {
      return {'name': null, 'profile': null};
    }
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

  Stream<int> jumlahPost(String idUser) {
    return _firestore
        .collection('post')
        .where('idUser', isEqualTo: idUser)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: StreamBuilder<int>(
              stream: jumlahPost(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // Menampilkan pesan error jika terjadi kesalahan
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                        ConnectionState.waiting ||
                    results == null) {
                  // Menampilkan indikator loading atau widget alternatif jika data masih dalam proses pengambilan
                  return const CircularProgressIndicator();
                } else {
                  // Menampilkan data jumlah post
                  int totalPost = snapshot.data ?? 0;
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(results!['profile']),
                                radius: 30,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                results!['name'],
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$totalPost',
                                style: GoogleFonts.notoSans(
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24),
                              ),
                              Text(
                                'postingan',
                                style: GoogleFonts.roboto(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
