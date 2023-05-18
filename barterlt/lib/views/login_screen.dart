import 'package:flutter/material.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.05,
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
                width: 300,
                height: 300,
                color: Colors.red,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: Center(
                          child: Text("Submit"),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
