import 'package:flutter/material.dart';
import 'package:penmetch/components/mbar.dart';
import 'package:penmetch/page/add.dart';
import 'package:penmetch/page/home.dart';
import 'package:penmetch/page/profile.dart';
import 'package:penmetch/page/search.dart';

class Layouts extends StatefulWidget {
  const Layouts({super.key});

  @override
  State<Layouts> createState() => _LayoutsState();
}

class _LayoutsState extends State<Layouts> {
    final list = <Widget>[
    const Home(),
    const Search(),
    const Add(),
    const Profile(),
  ];

  int selext = 0;

  void fot(int index) {
    setState(() {
      selext = index.clamp(0, list.length - 1);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      body: list[selext],
      bottomNavigationBar: Mbar(selext: selext, tabs: fot,),
    );
  }
}