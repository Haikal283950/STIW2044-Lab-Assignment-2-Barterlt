import 'package:flutter/material.dart';

class tab_page1 extends StatefulWidget {
  const tab_page1({super.key});

  @override
  State<tab_page1> createState() => _tab_page1State();
}

class _tab_page1State extends State<tab_page1> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(child: Text("POST TAB")),
    );
  }
}
