import 'package:barterlt/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barterlt',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
              displayLarge: TextStyle(
                  fontFamily: 'Gotham',
                  color: Color.fromARGB(255, 8, 9, 87),
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
              bodySmall: TextStyle(
                  fontFamily: 'Gotham',
                  color: Color.fromARGB(255, 8, 9, 87),
                  fontSize: 13),
              displaySmall: TextStyle(
                  fontFamily: 'Gotham', color: Colors.white, fontSize: 13))),
      home: Scaffold(
        body: Splash_screen(),
      ),
    );
  }
}
