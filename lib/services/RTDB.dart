import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';

class RTDB {
  static String pickedDateAsString = '';
  static String startingTimeAsString = '';
  static String endingTimeAsString = '';
  static String pickedDateForDateFetchingFromFirebase = '';

  static Future<List<weatherWithTime>> fetchData(String location,
      DateTime pickedDate, TimeOfDay startingTime, TimeOfDay endingTime) async {
    // formatting the starting date and time
    var formatter = new DateFormat('yyyy-MM-dd');
    var formatterForDateFetchingFromFirebase = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(pickedDate);
    String formattedDate2 =
        formatterForDateFetchingFromFirebase.format(pickedDate);
    pickedDateForDateFetchingFromFirebase = formattedDate2;
    pickedDateAsString = formattedDate;
    startingTimeAsString = startingTime.toString();
    endingTimeAsString = endingTime.toString();
    startingTimeAsString += ':00';
    endingTimeAsString += ':00';
    startingTimeAsString = startingTimeAsString
        .replaceAll('TimeOfDay', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    endingTimeAsString = endingTimeAsString
        .replaceAll('TimeOfDay', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    startingTimeAsString = startingTimeAsString.replaceAll('minified:bi', '');
    endingTimeAsString = endingTimeAsString.replaceAll('minified:bi', '');

    print(
        'pickedDate: $pickedDateAsString, staringTime: $startingTimeAsString, endingTime: $endingTimeAsString, pickedDateForDateFetchingFromFirebase: $pickedDateForDateFetchingFromFirebase');

    // fetch the data from real time database
    Query query = await FirebaseDatabase.instance
        .ref(location)
        .child('Date')
        .child(pickedDateForDateFetchingFromFirebase)
        .child('Time')
        .orderByKey()
        .startAt(startingTimeAsString)
        .endAt(endingTimeAsString);

    // printing the queried data which have been fetched from real time database
    DataSnapshot event = await query.get();
    print('Queried data is ${event.value}');

    List<weatherWithTime> weatherTimeList = [];

    if (event.value == null) return weatherTimeList;

    // inserting the data into the list from map
    var fetchedDataInMap = event.value as Map;
    fetchedDataInMap.forEach((k, v) {
      weatherTimeList.add(weatherWithTime(
          time: k, temperature: v['Temperature'], humidity: v['Humidity']));
    });

    // for (int i = 0; i < weatherTimeList.length; i++) {
    //   print(
    //       'List is : ${weatherTimeList[i].time} ${weatherTimeList[i].temperature} ${weatherTimeList[i].humidity}');
    // }


    return weatherTimeList;
  }

  static Future<void> insertData(String location,String temperature, String humidity) async {

    DateTime currentDateTime = DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(currentDateTime);
    String formattedTime = DateFormat.Hms().format(currentDateTime);
    String currentTime = formattedTime;
    String currentDate = formattedDate;

    // inserting the fetched data into real time database
    await FirebaseDatabase.instance
        .ref(location)
        .child('Date')
        .child(currentDate)
        .child('Time')
        .child(currentTime)
        .update({'Temperature': temperature, 'Humidity': humidity});
  }
}
