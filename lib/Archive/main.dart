import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirbhaya/home.dart';
import 'package:nirbhaya/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shake/shake.dart';
import 'package:nirbhaya/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(MyApp());
}

Future<void> initializeService() async{
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description:'This channel is used for important notifications',
    importance : Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();



  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ShakeDetector detector = ShakeDetector.autoStart(
    onPhoneShake: () async {
      print("Vishal --- service--> Shake detected!!");
      // _sendSMS;
      // sendDataUrl();
      // Do stuff on phone shake
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        print("-------------location mali gau have service ma------------");
        Position? _currentPosition;
        print("vishal service ma");
          _currentPosition = position;
          print('${_currentPosition?.latitude}');
          print('${_currentPosition?.longitude}');
          print("vishal service ma");

        print("vishal start api call thse have");
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


      }).catchError((e) {
        debugPrint(e);
      });

    },
    minimumShakeCount: 3,
    shakeSlopTimeMS: 500,
    shakeCountResetTime: 3000,
    shakeThresholdGravity: 2.7,
  );


  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      print("Vishal --- service--> setAsForeGround");
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      print("Vishal --- service--> setAsBackGround");
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
    print("Vishal --- service--> stop");
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  String? _latlng;
  bool loc = true;
  Position? _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String message = "";

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
    await _getCurrentPosition;
    var data = {
      "id": prefs.getString("Id"),
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

  void initState(){
    super.initState();


    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nirbhaya - Women Safety App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        textTheme: Theme.of(context).textTheme.apply(displayColor: textColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.all(defaultPadding),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: textFieldBorder,
          enabledBorder: textFieldBorder,
          focusedBorder: textFieldBorder,
        ),
      ),
      home: HomePage(),
    );
  }
}

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late final Timer timer;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      logs = sp.getStringList('log') ?? [];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
        return Text(log);
      },
    );
  }
}

