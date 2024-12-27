import 'package:connectivity_plus_tutorial/utils/globals.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Globals.hasInternet) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No Internet Connection!!",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    if (Globals.hasWeakConnection) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Weak Internet Connection!!",
            style: TextStyle(
              color: Colors.yellow,
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: Text(
          "Online",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
