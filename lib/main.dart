import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:real_time_weather_update/screens/dateTimePicking.dart';
import 'package:real_time_weather_update/screens/signIn.dart';
import 'package:real_time_weather_update/screens/tempVsTimeGraph.dart';
import 'package:real_time_weather_update/worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyD2H32KCXwo_ph7GZgeSLAYB95liP7nCYE",
          authDomain: "real-time-weather-update.firebaseapp.com",
          databaseURL:
              "https://real-time-weather-update-default-rtdb.firebaseio.com",
          projectId: "real-time-weather-update",
          storageBucket: "real-time-weather-update.appspot.com",
          messagingSenderId: "363558742256",
          appId: "1:363558742256:web:88114395510cbacc6a3a35",
          measurementId: "G-SF8R1574SR"));
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Real Time Weather Update',
      theme: ThemeData(primarySwatch: Colors.teal,brightness: Brightness.dark),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return worker();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
