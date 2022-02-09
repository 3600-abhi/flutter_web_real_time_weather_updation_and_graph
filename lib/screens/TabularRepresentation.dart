import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/services/RTDB.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:data_table_2/data_table_2.dart';

class TabularRepresentation extends StatefulWidget {
  String location = '';
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  TabularRepresentation(
      {Key? key, this.pickedDate, this.startingTime, this.endingTime})
      : super(key: key);

  @override
  _TabularRepresentationState createState() => _TabularRepresentationState(this.location,
      this.pickedDate, this.startingTime, this.endingTime);
}

class _TabularRepresentationState extends State<TabularRepresentation> {
  String location = '';
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  _TabularRepresentationState(this.location,this.pickedDate, this.startingTime, this.endingTime);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tabular Representation')),
      body: Center(
        child: FutureBuilder<List<weatherWithTime?>>(
          future: RTDB.fetchData(location,pickedDate!, startingTime!, endingTime!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Table is loading Please wait...'),
              );
            }else if(snapshot.data!.isEmpty) {
              return Center(child: Text('Sorry, No data found for this time range' , style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )));
            }
            else {
              print('length of the ${snapshot.data!.length}');
              return DataTable2(
                columns: getColumns(),
                rows: getRows(snapshot.data as List<weatherWithTime>),
              );
            }
          },
        ),
      ),
    );
  }
}

List<DataColumn> getColumns() {
  List<String> columnTable = ['Time', 'Temperature', 'Humidity'];
  return columnTable
      .map((e) => DataColumn(label: Text(e)))
      .toList();
}

List<DataRow> getRows(List<weatherWithTime> weatherTimeList) {
  return weatherTimeList.map((e) {
    List<String?> cells = [e.time, e.temperature, e.humidity];
    return DataRow(cells: getCells(cells));
  }).toList();
}

List<DataCell> getCells(List<String?> cells) {
  return cells.map((e) => DataCell(Text(e!))).toList();
}
