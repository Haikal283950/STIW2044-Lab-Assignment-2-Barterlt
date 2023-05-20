import 'package:barterlt/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class register_success extends StatefulWidget {
  const register_success({super.key});

  @override
  State<register_success> createState() => _register_successState();
}

class _register_successState extends State<register_success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Lottie.network(
                    'https://assets4.lottiefiles.com/packages/lf20_s2lryxtd.json'),
              ),
              Text(
                "Welcome to the club",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                width: 300,
                child: Text(
                  "Your account has been added, you may go back to the main screen",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 14, 54, 141),
                    onPrimary: Color.fromARGB(255, 244, 54, 181),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => main_screen()));
                  },
                  child: Center(
                    child: Text(
                      "Heck Yeah!",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
