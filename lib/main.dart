import 'package:anxi_pro/helper/functions.dart';
import 'package:anxi_pro/views/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:anxi_pro/views/login.dart';
import 'package:anxi_pro/views/record_home.dart';

// enum AudioState { recording, stop, play }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedInDetail();
    super.initState();
  }

  checkUserLoggedInDetail() async {
    HelperFunctions.getUserLoggedInDetails().then((val) {
      setState(() {
        _isLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mind Journal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'ubuntu',
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: (_isLoggedIn ?? false) ? Dashboard() : LogIn() //RecordScreen(),
        );
  }
}
