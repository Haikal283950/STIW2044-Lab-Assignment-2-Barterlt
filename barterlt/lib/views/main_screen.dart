import 'package:barterlt/views/login_screen.dart';
import 'package:barterlt/views/tab_page1.dart';
import 'package:barterlt/views/tab_page2.dart';
import 'package:barterlt/views/tab_page3.dart';
import 'package:flutter/material.dart';

class main_screen extends StatefulWidget {
  const main_screen({super.key});

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
  late List<Widget> tab_childs;
  int _currentIndex = 0;
  String mainTitle = "Trade";
  @override
  void initState() {
    super.initState();
    tab_childs = [tab_page1(), tab_page2(), tab_page3()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barterlt"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => login_screen()));
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: tab_childs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.abc_sharp),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory_sharp),
            label: "Trade",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_outlined),
            label: "Notifications",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        mainTitle = "Post";
      }
      if (_currentIndex == 1) {
        mainTitle = "Trade";
      }
      if (_currentIndex == 2) {
        mainTitle = "Notifications";
      }
    });
  }
}
