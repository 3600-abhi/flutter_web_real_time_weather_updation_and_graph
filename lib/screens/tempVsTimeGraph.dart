import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TemperatureVsTimeGraph extends StatefulWidget {
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  TemperatureVsTimeGraph(
      {Key? key, this.pickedDate, this.startingTime, this.endingTime})
      : super(key: key);

  @override
  _TemperatureVsTimeGraphState createState() => _TemperatureVsTimeGraphState(
      this.pickedDate, this.startingTime, this.endingTime);
}

class _TemperatureVsTimeGraphState extends State<TemperatureVsTimeGraph> {
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  String pickedDateAsString = '';
  String startingTimeAsString = '';
  String endingTimeAsString = '';
  String pickedDateForDateFetchingFromFirebase = '';

  _TemperatureVsTimeGraphState(
      this.pickedDate, this.startingTime, this.endingTime);

  List<weatherWithTime> weatherTimeList = [];

  Future<List<weatherWithTime>> fetchData() async {


    // formatting the starting date and time
    var formatter = new DateFormat('yyyy-MM-dd');
    var formatterForDateFetchingFromFirebase = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(pickedDate!);
    String formattedDate2 = formatterForDateFetchingFromFirebase.format(pickedDate!);
    String pickedDateForDateFetchingFromFirebase = formattedDate2;
    pickedDateAsString = formattedDate;
    startingTimeAsString = startingTime.toString();
    endingTimeAsString = endingTime.toString();
    startingTimeAsString += ':00';
    endingTimeAsString += ':00';
    startingTimeAsString = startingTimeAsString.replaceAll('TimeOfDay','').replaceAll('(', '').replaceAll(')', '');
    endingTimeAsString = endingTimeAsString.replaceAll('TimeOfDay','').replaceAll('(', '').replaceAll(')', '');
    startingTimeAsString =  startingTimeAsString.replaceAll('minified:bf', '');
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

    print('Namaste');

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
      appBar: AppBar(title: Text('Graphical Representation')),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Graph is loading please wait...'),
              );
            } else {
              return ListView(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: SfCartesianChart(
                      enableAxisAnimation: true,
                        primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.hours,
                            majorGridLines: MajorGridLines(width: 0),
                            title: AxisTitle(text: 'Time'),
                            // minimum: DateTime.now(),
                            minimum: DateTime.parse('$pickedDateAsString 00:00:00'),
                            maximum: DateTime.parse('$pickedDateAsString 23:59:59'),
                            desiredIntervals: 100,
                            dateFormat: DateFormat.Hms()),
                        primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          minimum: 0,
                          maximum: 50,
                          labelFormat: '{value}°C',
                          title: AxisTitle(text: 'Temperature'),
                        ),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        title: ChartTitle(text: 'Temperature Vs Time'),
                        series: <ChartSeries<weatherWithTime, DateTime>>[
                          LineSeries<weatherWithTime, DateTime>(
                            dataSource: weatherTimeList,
                            xValueMapper: (weatherWithTime currentData, _) =>
                                DateTime.parse(
                                    '$pickedDateAsString ' + currentData.time),
                            yValueMapper: (weatherWithTime currentData, _) =>
                                double.parse(currentData.temperature),
                            // dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ]),
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.hours,
                            majorGridLines: MajorGridLines(width: 0),
                            title: AxisTitle(text: 'Time'),
                            // minimum: DateTime.now(),
                            minimum: DateTime.parse('$pickedDateAsString 00:00:00'),
                            maximum: DateTime.parse('$pickedDateAsString 23:59:59'),
                            desiredIntervals: 100,
                            dateFormat: DateFormat.Hms()),
                        primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          minimum: 0,
                          maximum: 110,
                          labelFormat: '{value}°%',
                          title: AxisTitle(text: 'Humidity'),
                        ),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        title: ChartTitle(text: 'Humidity Vs Time'),
                        series: <ChartSeries<weatherWithTime, DateTime>>[
                          LineSeries<weatherWithTime, DateTime>(
                            dataSource: weatherTimeList,
                            xValueMapper: (weatherWithTime currentData, _) =>
                                DateTime.parse(
                                    '$pickedDateAsString ' + currentData.time),
                            yValueMapper: (weatherWithTime currentData, _) =>
                                double.parse(currentData.humidity),
                            // dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ]),
                  ),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}
