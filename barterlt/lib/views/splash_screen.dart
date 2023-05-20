import 'package:barterlt/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => main_screen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/market.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 224, 0, 86), BlendMode.darken))),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 0.20,
                  height: size.height * 0.22,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Bartlet-Logo.png"),
                          fit: BoxFit.fitHeight)),
                ),
                Container(
                  width: size.width * 0.17,
                  height: size.height * 0.12,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/gifs/customLoad.gif"),
                          fit: BoxFit.fitHeight)),
                ),
                Text(
                  "Version 0.1",
                  style: Theme.of(context).textTheme.displaySmall,
                )
              ]),
        )
      ],
    );
  }
}
