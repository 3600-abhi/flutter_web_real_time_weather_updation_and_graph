import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/screens/graph_demo.dart';
import 'package:real_time_weather_update/screens/signIn.dart';
import 'package:real_time_weather_update/screens/tempVsTimeGraph.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:real_time_weather_update/services/authentication.dart';

class worker extends StatefulWidget {
  const worker({Key? key}) : super(key: key);

  @override
  _workerState createState() => _workerState();
}

class _workerState extends State<worker> {
  final user = FirebaseAuth.instance.currentUser;

  String location = 'New Delhi';
  String temperature = '';
  String humidity = '';

  Future<weatherWithTime> getData() async {
    // get the weather data from the weather map API
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=d56eb9af33f2e453687a7ed57ba39269");
    var response = await get(url);
    Map data = jsonDecode(response.body);

    // print(data);

    // get current date and time
    DateTime currentDateTime = DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(currentDateTime);
    String formattedTime = DateFormat.Hms().format(currentDateTime);
    String currentTime = formattedTime;
    String currentDate = formattedDate;
    // print('current date is $currentDate');
    // print('current time is $currentTime');

    //  get temperature and humidity
    temperature = (data['main']['temp'] - 273.15).toString().substring(0, 5);
    humidity = data['main']['humidity'].toString();

    // inserting the fetched data into real time databse
    await FirebaseDatabase.instance
        .ref('Weather Report')
        .child('Date')
        .child(currentDate)
        .child('Time')
        .child(currentTime)
        .update({'Temperature': temperature, 'Humidity': humidity});

    // returnning the weather report to stream
    weatherWithTime currData = weatherWithTime(
        time: currentTime, temperature: temperature, humidity: humidity);

    return currData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Real Time Weather Update'), centerTitle: true),
      body: Container(
        child: StreamBuilder(
          stream:
              Stream.periodic(Duration(seconds: 4)).asyncMap((i) => getData()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome ${user!.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.blue)),
                    SizedBox(height: 10),
                    Text('Current Time : ${snapshot.data!.time}',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple)),
                    SizedBox(height: 10),
                    Text('Current Temperature : ${snapshot.data!.temperature}',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    SizedBox(height: 10),
                    Text('Current Humidity : ${snapshot.data!.humidity}',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        child: Text('SignOut', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          signInAuthUsingEmailAndPassword.signOutAuth().then(
                              (value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login())));
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        child: Text('See Graph'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TemperatureVsTimeGraph()));
                        }),



                    SizedBox(height: 20),
                    ElevatedButton(
                        child: Text('See Demo Graph'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      graphDemo()));
                        })
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
