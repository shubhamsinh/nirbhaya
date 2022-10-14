import 'package:flutter/material.dart';
import 'package:nirbhaya/home.dart';
import 'package:nirbhaya/home_screen.dart';
import 'package:nirbhaya/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/nirbhaya_app_logo1.png"),
          SizedBox(height: 80,),
          SizedBox(
            width: 420,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text("Get Started"),
            ),
          ),
        ],
      )
    );
  }
}
