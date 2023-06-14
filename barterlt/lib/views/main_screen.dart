import 'package:barterlt/views/add_item.dart';
import 'package:barterlt/views/login_screen.dart';
import 'package:barterlt/views/tab_page1.dart';
import 'package:barterlt/views/tab_page2.dart';
import 'package:barterlt/views/tab_page3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../model/user.dart';

class main_screen extends StatefulWidget {
  final User user;
  const main_screen({super.key, required this.user});

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
    print(widget.user.first_name);
    _showRoundedSnackbar(context, "${widget.user.first_name ?? ''}");
    tab_childs = [
      tab_page1(
        user: widget.user,
      ),
      tab_page2(),
      tab_page3()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Barterlt",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => login_screen()));
              },
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 8, 9, 87),
              ))
        ],
      ),
      body: tab_childs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Posts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Trade",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          overlayOpacity: 0.2,
          icon: Icons.menu,
          activeIcon: Icons.close,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 8, 9, 87),
          foregroundColor: Colors.white,
          children: [
            SpeedDialChild(
              shape: CircleBorder(),
              child: Icon(Icons.add),
              onTap: () {
                //TODO NAVIGATION
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => add_item(
                              user: widget.user,
                            )));
              },
            ),
          ]),
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

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');
    prefs.setString('password', '');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  void _showRoundedSnackbar(BuildContext context, String userText) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Text(
        "Welcome back $userText",
        style: TextStyle(color: Colors.white, fontFamily: "gotham"),
      ),
      duration: Duration(seconds: 3),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(widget.user.user_id);
    });
  }
}
