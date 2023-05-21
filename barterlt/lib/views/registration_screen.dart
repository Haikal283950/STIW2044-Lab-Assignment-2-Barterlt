import 'dart:async';
import 'dart:convert';

import 'package:barterlt/views/login_screen.dart';
import 'package:barterlt/views/main_screen.dart';
import 'package:barterlt/views/register_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class registration_screen extends StatefulWidget {
  const registration_screen({super.key});

  @override
  State<registration_screen> createState() => _registration_screenState();
}

class _registration_screenState extends State<registration_screen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _lastNameEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String helper = "";

  @override
  void dispose() {
    _firstNameEditingController.dispose();
    _emailEditingController.dispose();
    _usernameEditingController.dispose();
    _passwordEditingController.dispose();
    _lastNameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 14, 54, 141),
            )),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Join the best \ntrading platform \nof all time",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Join us as we embark on a new adventure!",
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  height: size.height * 0.4,
                  //This is where the width of the image is defined
                  width: size.height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/Barterlt-Regist.png"))),
                ),
                //START OF THE FORM
                Form(
                  autovalidateMode: _autoValidateMode,
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                        child: TextFormField(
                          controller: _emailEditingController,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".com")
                              ? "Enter a valid email"
                              : null,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "Email",
                              filled: true,
                              fillColor: Color.fromARGB(255, 214, 226, 240),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          controller: _usernameEditingController,
                          validator: (value) => value!.isEmpty ||
                                  value.length < 4 ||
                                  value.length > 25
                              ? "Pleaase enter a valid Username"
                              : null,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "Username",
                              filled: true,
                              fillColor: Color.fromARGB(255, 214, 226, 240),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              helper =
                                  "Password must atleast :\n - Minimum 6 characters\n and atleast have 1:\n- Special character\n- Uppercase letter\n- Lowercase letter\n- Number";
                            });
                          },
                          controller: _passwordEditingController,
                          validator: (value) =>
                              value!.isEmpty || !regex.hasMatch(value)
                                  ? "Enter a valid password"
                                  : null,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "BartletIsAwesome212!",
                              helperText: helper,
                              prefixIcon: GestureDetector(
                                child: Icon(Icons.lock),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "Password",
                              filled: true,
                              fillColor: Color.fromARGB(255, 214, 226, 240),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          controller: _firstNameEditingController,
                          validator: (value) => value!.isEmpty ||
                                  value.length < 4 ||
                                  value.length > 25
                              ? "Please enter a valid name"
                              : null,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "First Name",
                              filled: true,
                              fillColor: Color.fromARGB(255, 214, 226, 240),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: TextFormField(
                          controller: _lastNameEditingController,
                          validator: (value) => value!.isEmpty ||
                                  value.length < 4 ||
                                  value.length > 25
                              ? "Please enter a valid name"
                              : null,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "Last Name",
                              filled: true,
                              fillColor: Color.fromARGB(255, 214, 226, 240),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35))),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 14, 54, 141),
                      onPrimary: Color.fromARGB(255, 244, 54, 181),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                    ),
                    onPressed: () {
                      print(_usernameEditingController.text);
                      setState(() {
                        _autoValidateMode = AutovalidateMode.always;
                        Timer(Duration(milliseconds: 100), () {
                          setState(() {
                            _autoValidateMode = AutovalidateMode.disabled;
                          });
                        });
                      });
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: Center(
                      child: Text(
                        "Register now",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    )),
                Text(
                  "Already have an account ?",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => login_screen())));
                    },
                    child: Text("Login Here")),
                SizedBox(
                  height: size.height * 0.01,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    String _first_name = _firstNameEditingController.text;
    String _last_name = _lastNameEditingController.text;
    String _password = _passwordEditingController.text;
    String _email = _emailEditingController.text;
    String _username = _usernameEditingController.text;
    http.post(Uri.parse('http://10.0.2.2/barterlt/php/register.php'), body: {
      "first_name": _first_name,
      "last_name": _last_name,
      "email": _email,
      "password": _password,
      "username": _username
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => register_success()));
      } else {
        print(response.statusCode);
      }
    });
  }
}
