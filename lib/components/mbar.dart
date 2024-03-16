import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class Mbar extends StatefulWidget {
  final int selext;
  final ValueChanged<int> tabs;
  const Mbar({super.key, required this.selext, required this.tabs});

  @override
  State<Mbar> createState() => _MbarState();
}

class _MbarState extends State<Mbar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MoltenBottomNavigationBar(
      selectedIndex: widget.selext,
      onTabChange: widget.tabs,
      barColor: const Color.fromRGBO(20, 20, 20, 0.8),
      curve: Curves.easeInOut,
      barHeight: 60,
      borderRaduis: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      domeCircleColor: Colors.blue.shade700,
      tabs: [
        MoltenTab(
            icon: const Icon(
              Icons.home,
              size: 30,
            ),
            selectedColor: const Color.fromRGBO(500, 500, 500, 1),
            unselectedColor: const Color.fromRGBO(120, 120, 120, 1),
            title: Text(
              'home',
              style: GoogleFonts.notoSans(
                  color: const Color.fromRGBO(180, 180, 180, 1),
                  fontWeight: FontWeight.w500),
            )),
        MoltenTab(
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            selectedColor: const Color.fromRGBO(500, 500, 500, 1),
            unselectedColor: const Color.fromRGBO(120, 120, 120, 1),
            title: Text(
              'search',
              style: GoogleFonts.notoSans(
                  color: const Color.fromRGBO(180, 180, 180, 1),
                  fontWeight: FontWeight.w500),
            )),
        MoltenTab(
            icon: const Icon(
              Icons.post_add,
              size: 30,
            ),
            selectedColor: const Color.fromRGBO(500, 500, 500, 1),
            unselectedColor: const Color.fromRGBO(120, 120, 120, 1),
            title: Text(
              'posting',
              style: GoogleFonts.notoSans(
                  color: const Color.fromRGBO(180, 180, 180, 1),
                  fontWeight: FontWeight.w500),
            )),
        MoltenTab(
            icon: const Icon(
              Icons.account_box,
              size: 30,
            ),
            selectedColor: const Color.fromRGBO(500, 500, 500, 1),
            unselectedColor: const Color.fromRGBO(120, 120, 120, 1),
            title: Text(
              'profile',
              style: GoogleFonts.notoSans(
                  color: const Color.fromRGBO(180, 180, 180, 1),
                  fontWeight: FontWeight.w500),
            )),
      ],
    ));
  }
}