import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:data_table_2/data_table_2.dart';

class TabularRepresentation extends StatefulWidget {
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  TabularRepresentation(
      {Key? key, this.pickedDate, this.startingTime, this.endingTime})
      : super(key: key);

  @override
  _TabularRepresentationState createState() => _TabularRepresentationState(
      this.pickedDate, this.startingTime, this.endingTime);
}

class _TabularRepresentationState extends State<TabularRepresentation> {
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  String pickedDateAsString = '';
  String startingTimeAsString = '';
  String endingTimeAsString = '';
  String pickedDateForDateFetchingFromFirebase = '';

  _TabularRepresentationState(
      this.pickedDate, this.startingTime, this.endingTime);

  static List<weatherWithTime> weatherTimeList = [];

  // data for tables
  static List<String> columnTable = ['Time', 'Temperature', 'Humidity'];

  Future<List<weatherWithTime>> fetchData() async {
    // formatting the starting date and time
    var formatter = new DateFormat('yyyy-MM-dd');
    var formatterForDateFetchingFromFirebase = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(pickedDate!);
    String formattedDate2 =
        formatterForDateFetchingFromFirebase.format(pickedDate!);
    String pickedDateForDateFetchingFromFirebase = formattedDate2;
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
    startingTimeAsString = startingTimeAsString.replaceAll('minified:bf', '');
    endingTimeAsString = endingTimeAsString.replaceAll('minified:bf', '');

    print(
        'pickedDate: $pickedDateAsString, staringTime: $startingTimeAsString, endingTime: $endingTimeAsString, pickedDateForDateFetchingFromFirebase: $pickedDateForDateFetchingFromFirebase');

    // fetch the data from real time database
    Query query = await FirebaseDatabase.instance
        .ref('Weather Report')
        .child('Date')
        .child(pickedDateForDateFetchingFromFirebase)
        .child('Time')
        .orderByKey()
        .startAt(startingTimeAsString)
        .endAt(endingTimeAsString);

    // printing the queried data which have been fetched from real time database
    DataSnapshot event = await query.get();
    print('Queried data is ${event.value}');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tabular Representation')),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Table is loading please wait...'),
              );
            } else {
              return DataTable2(
                  columns: getColumns(),
                  rows: getRows(),
              );
            }
          },
        ),
      ),
    );
  }
}

List<DataColumn> getColumns() {
  return _TabularRepresentationState.columnTable.map((e) => DataColumn(label: Text(e))).toList();
}

List<DataRow> getRows() {
  return _TabularRepresentationState.weatherTimeList.map((e) {
    List<String> cells = [e.time,e.temperature,e.humidity];
    return DataRow(cells: getCells(cells));
  }).toList();
}

List<DataCell> getCells(List<String> cells) {
  return cells.map((e) => DataCell(Text(e))).toList();
}
