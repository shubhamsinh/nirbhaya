
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nirbhaya/fakecall_screen.dart';
import 'package:nirbhaya/helpline_screen.dart';
import 'package:nirbhaya/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'contact_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final assetsAudioPlayer = AssetsAudioPlayer();
  String? _latlng;
  bool loc = true;
  Position? _currentPosition;
  late SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String name = "";
  String message = "";

  Future<void> loadName() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("Name")!;
    setState(() {

    });
}

  Future<void> _sendSMS() async {
    prefs = await SharedPreferences.getInstance();
    await _getCurrentPosition();
    print("hello");
    print('${_currentPosition?.latitude}');
    List<String> recipients = prefs.getStringList('nums') ?? [];

    if (recipients.length == 0) {
      Alert(
              context: context,
              type: AlertType.warning,
              title: "CONTACT ALERT",
              desc: "\nNo contacts found! \n\n Please add contacts..! ")
          .show();
    } else {
      String message = "Help me! I am in trouble!!";
      if (loc) {
        _latlng =
            '${_currentPosition?.latitude},${_currentPosition?.longitude}';
        // String lat = '${_currentPosition?.latitude}';
        // String lng = '${_currentPosition?.longitude}';
        //
        // String name="Nirbhaya";
        // var data = {
        //   "id": 1,
        //   "name": "Nirbhaya",
        //   "lat": '${_currentPosition?.latitude}',
        //   "lng": '${_currentPosition?.longitude}'
        // };
        // var url=Uri.parse("http://demonirbhaya.000webhostapp.com/location.php");
        // var response=await http.post(url,body: data);
        // print(response);

        print(_latlng);
        message +=
            '\n\nMy current location is:\nhttps://www.google.com/maps/search/?api=1&query=' +
                _latlng!;
      }
      SmsSender sender = new SmsSender();
      print(recipients);

      for(int i=0; i<recipients.length;i++){
        SmsMessage message1 = new SmsMessage(recipients[i], message);
        message1.onStateChanged.listen((state) {
          if (state == SmsMessageState.Sent) {
            print("vishal");
            print("SMS is sent!");

            sendDataUrl();
            Alert(
                context: context,
                type: AlertType.success,
                title: "ALERT SENT",
                desc: "\nAll emergency contacts have been notified. ")
                .show();
          } else if (state == SmsMessageState.Delivered) {
            print("vishal");
            print("SMS is delivered!");
            // print(messageBody);
          }
        });
        sender.sendSms(message1);
      }
    }
  }

  Future sendDataUrl() async{
    prefs = await SharedPreferences.getInstance();
    // String lat = '${_currentPosition?.latitude}';
    // String lng = '${_currentPosition?.longitude}';
    //
    // String name="Nirbhaya";
    print("vishal start api call thse have");
    await _getCurrentPosition();
    var data = {
      "id": prefs.getString('Id'),
      "name": prefs.getString('Name'),
      "lat": '${_currentPosition?.latitude}',
      "lng": '${_currentPosition?.longitude}'
    };
    print(data);
    var url=Uri.parse("http://demonirbhaya.000webhostapp.com/location.php");
    // var response = await http.post(url, body: data);

    var response=await http.post(url,body: data);
    print("vishal start api call thai gyo");
    print(response.body);
    print(response.statusCode);
    print("vishal start api call reponse aavi gayo :)");
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      print("vishal");
      print("Not permitted");
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print("-------------location mali gau------------");
      setState(() {
        _currentPosition = position;
        print('${_currentPosition?.latitude}');
        print('${_currentPosition?.longitude}');
        print("vishal");
        loc = true;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadName();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, '+name,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'How are you feeling today?',
                          style:
                              TextStyle(color: Colors.pinkAccent, fontSize: 15),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: HexColor('#403b7e'),
                      backgroundImage: AssetImage('assets/images/female_profile.png'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.white, Colors.white], radius: 2.5)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width - 10,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 70.0, // soften the shadow
                                spreadRadius: 20.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  0.0, // Move to bottom 5 Vertically
                                ),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(1000),
                            gradient: RadialGradient(radius: 0.7, colors: [
                              HexColor('#9C204E'),
                              HexColor('#2B60DE'),
                            ]),
                            border: Border.all(
                                color: HexColor('#1568C7'), width: 2)),
                        child: AvatarGlow(
                          endRadius: 200.0,
                          startDelay: Duration(seconds: 1),
                          glowColor: Colors.blueAccent,
                          child: CircleList(
                            initialAngle: 55,
                            outerRadius:
                                MediaQuery.of(context).size.width / 2.2,
                            innerRadius: MediaQuery.of(context).size.width / 5,
                            showInitialAnimation: true,
                            innerCircleColor: Colors.white54,
                            outerCircleColor: Colors.white30,
                            origin: Offset(0, 0),
                            rotateMode: RotateMode.onlyChildrenRotate,
                            centerWidget: InkWell(
                              onDoubleTap: () {},
                              child: Container(
                                child: Image.asset(
                                  "assets/images/nirbhaya_app_logo1.png",
                                  height: 120,
                                ),
                                // child: Text('\n\nNirbhaya\n\n',
                                //   style: TextStyle(color: HexColor('#FE4365'),
                                //       fontFamily: 'Raleway', fontSize: 15),
                                //   textAlign: TextAlign.center,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white70,
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 15.0, //extend the shadow
                                      offset: Offset(
                                        0.0, // Move to right 10  horizontally
                                        0.0, // Move to bottom 5 Vertically
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            children: [
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: (){
                                      _sendSMS();
                                      // sendDataUrl();
                                      // String lat = '${_currentPosition?.latitude}';
                                      // String lng = '${_currentPosition?.longitude}';
                                      //
                                      // String name="Nirbhaya";
                                      // var data = {
                                      //   "id": 1,
                                      //   "name": "Nirbhaya",
                                      //   "lat": '${_currentPosition?.latitude}',
                                      //   "lng": '${_currentPosition?.longitude}'
                                      // };
                                      // var url=Uri.parse("http://demonirbhaya.000webhostapp.com/location.php");
                                      // var response=await http.post(url,body: data);
                                      // print(response);
                                    },
                                    // onPressed: _sendSMS,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.add_alert,
                                            size: 40,
                                            color: HexColor('#2B60DE')),
                                        Text(
                                          'Alert',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Contacts()),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.person_add,
                                          size: 40,
                                          color: HexColor('#2B60DE'),
                                        ),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: () {
                                      assetsAudioPlayer.open(
                                          Audio('assets/music/police.mp3'));
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 155.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 15.0,
                                                        color: Colors.orange,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3000.0),
                                                    ),
                                                    // ignore: deprecated_member_use
                                                    child: RaisedButton(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1000.0)),
                                                      onPressed: () => {
                                                        assetsAudioPlayer
                                                            .stop(),
                                                        Navigator.pop(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WelcomeScreen())),
                                                      },
                                                      child: Container(
                                                        width: 220,
                                                        height: 250,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Tap to\nstop',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Raleway'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.speaker_phone,
                                          size: 40,
                                          color: HexColor('#2B60DE'),
                                        ),
                                        Text(
                                          'Siren',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //(siren)
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: HexColor('#2B60DE'),
                                        ),
                                        Text(
                                          'Photo',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 11,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FakecallPage()),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          size: 40,
                                          color: HexColor('#2B60DE'),
                                        ),
                                        Text(
                                          'Call',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AvatarGlow(
                                endRadius: 70.0,
                                glowColor: Colors.pink,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: HexColor('#2B60DE'),
                                          width: 3)),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 1,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HelplinePage()),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.help_outline,
                                          size: 40,
                                          color: HexColor('#2B60DE'),
                                        ),
                                        Text(
                                          'Helpline',
                                          style: TextStyle(
                                              color: HexColor('#2B60DE'),
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
