import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:real_time_weather_update/services/RTDB.dart';

class TemperatureVsTimeGraph extends StatefulWidget {
  String location = '';
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  TemperatureVsTimeGraph(
      {Key? key, required this.location,this.pickedDate, this.startingTime, this.endingTime})
      : super(key: key);

  @override
  _TemperatureVsTimeGraphState createState() => _TemperatureVsTimeGraphState(this.location,
      this.pickedDate, this.startingTime, this.endingTime);
}

class _TemperatureVsTimeGraphState extends State<TemperatureVsTimeGraph> {
  String location = '';
  DateTime? pickedDate;
  TimeOfDay? startingTime;
  TimeOfDay? endingTime;

  ScreenshotController screenshotController = ScreenshotController();

  _TemperatureVsTimeGraphState(this.location,
      this.pickedDate, this.startingTime, this.endingTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Graphical Representation')),
      body: Center(
        child: FutureBuilder<List<weatherWithTime>>(
          future: RTDB.fetchData(location,
              pickedDate!, startingTime!, endingTime!),
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Graph is loading Please wait...'),
              );
            } else if (snapshot.data!.isEmpty || snapshot.hasError) {
              return Center(
                  child: Text('Sorry, No data found for this time range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )));
            } else {
              return ListView(
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: SfCartesianChart(
                                enableAxisAnimation: true,
                                primaryXAxis: DateTimeAxis(
                                    intervalType: DateTimeIntervalType.hours,
                                    majorGridLines: MajorGridLines(width: 1),
                                    title: AxisTitle(text: 'Time'),
                                    minimum: DateTime.parse(
                                        '${RTDB.pickedDateAsString} 00:00:00'),
                                    maximum: DateTime.parse(
                                        '${RTDB.pickedDateAsString} 23:59:59'),
                                    desiredIntervals: 100,
                                    dateFormat: DateFormat.Hms()),
                                primaryYAxis: NumericAxis(
                                  majorGridLines: MajorGridLines(width: 1),
                                  minimum: 0,
                                  maximum: 50,
                                  labelFormat: '{value}°C',
                                  title: AxisTitle(text: 'Temperature'),
                                ),
                                title: ChartTitle(text: 'Temperature Vs Time'),
                                series: <
                                    ChartSeries<weatherWithTime, DateTime>>[
                                  LineSeries<weatherWithTime, DateTime>(
                                    dataSource: snapshot.data! ,
                                    xValueMapper:
                                        (weatherWithTime? currentData, _) =>
                                            DateTime.parse(RTDB.pickedDateAsString + ' ' + currentData!.time) ,
                                    yValueMapper: (weatherWithTime? currentData,
                                            _) =>
                                    double.parse(currentData!.temperature),
                                    opacity: 1,
                                  )
                                ]),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                    intervalType: DateTimeIntervalType.hours,
                                    majorGridLines: MajorGridLines(width: 1),
                                    title: AxisTitle(text: 'Time'),
                                    minimum: DateTime.parse(
                                        '${RTDB.pickedDateAsString} 00:00:00'),
                                    maximum: DateTime.parse(
                                        '${RTDB.pickedDateAsString} 23:59:59'),
                                    desiredIntervals: 24,
                                    dateFormat: DateFormat.Hms(),
                                    ),
                                primaryYAxis: NumericAxis(
                                  majorGridLines: MajorGridLines(width: 1),
                                  minimum: 0,
                                  maximum: 100,
                                  labelFormat: '{value}°%',
                                  title: AxisTitle(text: 'Humidity'),
                                ),
                                // legend: Legend(isVisible: true),
                                // tooltipBehavior: TooltipBehavior(enable: true),
                                title: ChartTitle(text: 'Humidity Vs Time'),
                                series: <
                                    ChartSeries<weatherWithTime, DateTime>>[
                                  LineSeries<weatherWithTime, DateTime>(
                                    dataSource: snapshot.data! ,
                                    xValueMapper:
                                        (weatherWithTime? currentData, _) =>
                                            DateTime.parse(RTDB
                                                    .pickedDateAsString +
                                                ' ' +
                                                currentData!.time),
                                    yValueMapper:
                                        (weatherWithTime? currentData, _) =>
                                            double.parse(currentData!.humidity),
                                    // emptyPointSettings: EmptyPointSettings(
                                    //   mode: EmptyPointMode.gap,
                                    // ),
                                    opacity: 1,
                                    // dataLabelSettings: DataLabelSettings(isVisible: true),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                      child: ElevatedButton(
                    child: Text('Download the Graph'),
                    onPressed: () {
                      screenshotController.capture().then((Uint8List? value) {
                        final _base64 = base64Encode(value!);
                        final anchor = AnchorElement(
                            href:
                                'data:application/octet-stream;base64,$_base64')
                          ..download = "Graph.png"
                          ..target = 'blank';

                        document.body!.append(anchor);
                        anchor.click();
                        anchor.remove();
                      });
                    },
                  )),
                  SizedBox(height: 30),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


