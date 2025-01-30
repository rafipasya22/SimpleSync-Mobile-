import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pab_pbl/pages/homepage.dart';
import 'package:pab_pbl/pages/meds.dart';
import 'package:pab_pbl/pages/profile.dart';

class nav extends StatefulWidget {
  const nav({super.key});

  @override
  State<nav> createState() => navState();
}

class navState extends State<nav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const Meds(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ClipRRect(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: GNav(
              selectedIndex: _selectedIndex,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              color: Colors.black,
              activeColor: const Color.fromARGB(255, 38, 194, 255),
              tabBackgroundColor: const Color.fromARGB(255, 231, 231, 231),
              gap: 8,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: "Home",
                ),
                GButton(
                  icon: LineIcons.pills,
                  text: "Medications",
                ),
                GButton(
                  icon: LineIcons.user,
                  text: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
