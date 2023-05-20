import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class tab_page1 extends StatefulWidget {
  const tab_page1({super.key});

  @override
  State<tab_page1> createState() => _tab_page1State();
}

class _tab_page1State extends State<tab_page1> {
  String username = '';
  String password = '';
  @override
  void initState() {
    super.initState();
    checkLog();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(child: Text("Welcome back " + username)),
    );
  }

  void checkLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = (prefs.getString('username')) ?? '';
    password = (prefs.getString('password')) ?? '';
  }
}
