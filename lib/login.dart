import 'package:flutter/material.dart';
import 'package:nirbhaya/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
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
                    builder: (context) => HomeScreen(),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text("SIGN UP"),
              ),
            ),
            SizedBox(height: 80,),
            SizedBox(
              width: 420,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text("SIGN IN"),
              ),
            ),

          ],
        )
    );
  }
}
