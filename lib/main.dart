import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_tutorial/screens/home_screen.dart';
import 'package:connectivity_plus_tutorial/screens/welcome_screen.dart';
import 'package:connectivity_plus_tutorial/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? subscription;

  Timer? networkTimer;

  checkNetworkStrength() {
    networkTimer = Timer.periodic(
        const Duration(
          seconds: 10,
        ), (timer) async {
      try {
        // Test internet speed by making a small request
        final stopwatch = Stopwatch()..start();
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        stopwatch.stop();

        if (response.statusCode == 200) {
          // Weak connection if response takes too long
          const thresholdInMillis = 3000; // Adjust based on your needs
          var isSlow = stopwatch.elapsedMilliseconds > thresholdInMillis;

          print("Is Connection Slow: " + isSlow.toString());

          if (isSlow) {
            setState(() {
              Globals.hasInternet = true;
              Globals.hasWeakConnection = true;
            });
          } else {
            setState(() {
              Globals.hasInternet = true;
              Globals.hasWeakConnection = false;
            });
          }
        } else {
          // Problem navigating to site
          setState(() {
            Globals.hasInternet = false;
            Globals.hasWeakConnection = true;
          });
        }
      } catch (e) {
        // Handle exceptions (e.g., timeout)
        setState(() {
          Globals.hasInternet = false;
          Globals.hasWeakConnection = false;
        });
      }
    });
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    setState(() {
      _connectionStatus = result;
      Globals.hasInternet = !result.contains(ConnectivityResult.none);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();

    subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // Received changes in available connectivity types!
      // print(result);
      setState(() {
        _connectionStatus = result;
        Globals.hasInternet = !result.contains(ConnectivityResult.none);
      });

      print('Connectivity changed: $_connectionStatus');
    });

    checkNetworkStrength();
  }

  @override
  void dispose() {
    subscription!.cancel();
    if (networkTimer != null) {
      networkTimer!.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connectivity Plus Tutorial',
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
    );
  }
}
