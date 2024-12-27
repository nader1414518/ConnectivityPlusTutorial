import 'dart:async';

import 'package:connectivity_plus_tutorial/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Timer? timer;
  int timerStart = 2;

  startTimer() {
    timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      if (timerStart <= 0) {
        timer.cancel();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else {
        setState(() {
          timerStart--;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: MediaQuery.sizeOf(context).width * 0.3,
        ),
      ),
    );
  }
}
