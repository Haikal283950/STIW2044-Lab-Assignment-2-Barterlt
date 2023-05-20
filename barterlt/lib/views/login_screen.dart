import 'dart:convert';

import 'package:barterlt/views/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 14, 54, 141),
            )),
      ),
      body:
          ListView(reverse: true, physics: BouncingScrollPhysics(), children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      "Hallo!",
                      style: Theme.of(context).textTheme.displayLarge,
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Ready to get back to trading ?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Container(
                  width: size.height * 0.42,
                  height: size.height * 0.42,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/Barterlt-login.png"))),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            labelText: "Username",
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 226, 240),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35))),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            labelText: "Password",
                            filled: true,
                            fillColor: Color.fromARGB(255, 214, 226, 240),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35))),
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 14, 54, 141),
                            onPrimary: Color.fromARGB(255, 244, 54, 181),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35)),
                          ),
                          onPressed: () {
                            // sendRequest();
                          },
                          child: Center(
                            child: Text(
                              "Submit",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          )),
                      Text(
                        "New here ?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        registration_screen()));
                          },
                          child: Text(
                            "Register Here",
                            style: TextStyle(fontFamily: "Gotham", height: 0.1),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  //TESTING OUT PHP
  // Future<void> sendRequest() async {
  //   var url = Uri.parse('http://10.19.59.108');
  //   var response = await http.get(url);
  //   print(response.statusCode);
  // }
}
