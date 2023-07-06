import 'dart:convert';
import 'package:barterlt/views/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../myConfig.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  TextEditingController _usernameControl = TextEditingController();
  TextEditingController _passwordControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _usernameControl.dispose();
    _passwordControl.dispose();
    super.dispose();
  }

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
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameControl,
                              validator: (value) => value!.isEmpty
                                  ? "Please insert your username"
                                  : null,
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
                              controller: _passwordControl,
                              obscureText: true,
                              validator: (value) => value!.isEmpty
                                  ? "Please insert your Password"
                                  : null,
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
                          ],
                        ),
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
                            if (_formKey.currentState!.validate()) {
                              sendRequest();
                            } else {
                              print("invalid");
                            }
                          },
                          child: Center(
                            child: Text(
                              "Login",
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

  Future<void> sendRequest() async {
    String username = _usernameControl.text;
    String password = _passwordControl.text;

    http.post(Uri.parse(server + '/barterlt/php/login.php'), body: {
      "username": username,
      "password": password
    }).then((response) async {
      if (response.statusCode == 200 && response.body != "failed") {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        User user = User.fromJson(jsonResponse);
        _showDialog(context);
        setState(() {});
      } else if (response.body == "failed") {
        print("Fail");
      }
    }).catchError((e) {
      _showError(context);
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login success!"),
            content: Container(
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  LottieBuilder.network(
                      'https://assets4.lottiefiles.com/packages/lf20_s2lryxtd.json'),
                  Text(
                    "Welcome back buddy!",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Back to menu!"))
            ],
          );
        });
  }

  void _showError(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid account!"),
            content: Container(
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  LottieBuilder.network(
                      'https://assets5.lottiefiles.com/packages/lf20_mrrytuew.json'),
                  Text(
                    "Invalid account! Check again!",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }
}
