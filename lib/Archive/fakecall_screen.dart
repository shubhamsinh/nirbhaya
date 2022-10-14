import 'package:flutter/material.dart';

class FakecallPage extends StatelessWidget {
  const FakecallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Icon(Icons.person,color: Colors.blueGrey,size: 80,),
            Text("Home",),
            Text("8128734037"),
            SizedBox(height: 80,),
            Row(
              children: [
                Column(
                  children: [
                    Icon(Icons.call_end_rounded),
                    Text("Decline")
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.call_outlined),
                    Text("Answer")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
