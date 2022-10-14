import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nirbhaya/constants.dart';
import 'package:nirbhaya/home_screen.dart';
import 'package:nirbhaya/profile_screen.dart';
import 'package:nirbhaya/signin_screen.dart';
// import 'package:women_safety_app/theme.dart';

// import 'Laws.dart';
// import 'Tips.dart';
// import 'change_theme.dart';
import 'contact_screen.dart';
import 'home.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBar createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar>
{
  int _currentindex = 0;
  final List<Widget> _children =
  [
    HomeScreen(),
    Contacts(),
    SigninPage()
    // Tips(),
    // Laws(),
  ];

  void onTappedBar(int index)
  {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _children[_currentindex],

        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: HexColor('#403b7e'),
          color:HexColor('#403b7e'),
          backgroundColor: Colors.white,
          // backgroundColor: ChangeTheme.of(context).theme == Themes.dark ? Theme.of(context).shadowColor : Colors.cyan,
          height: 75,
          onTap: onTappedBar ,
          items: <Widget>[
            // Icon(Icons.home, size: 30,color: HexColor('#434085')),
            Icon(Icons.home, size: 30,color: Colors.white),
            Icon(Icons.privacy_tip, size: 30,color: Colors.white),
            Icon(Icons.list_alt, size: 30,color: Colors.white),
          ],
        ),
      ),
    );
    return materialApp;
  }
}
