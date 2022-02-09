import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:real_time_weather_update/services/RTDB.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';

class Graph extends StatelessWidget {

  String location = '';
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  Graph({this.pickedDate, this.startingTime, this.endingTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: SimpleTimeSeriesChart.withSampleData(
        location,
          pickedDate, startingTime, endingTime),
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  // List<charts.Series> seriesList;
  // bool? animate;

  static String location = '';
  static DateTime? pickedDate = null;
  static TimeOfDay? startingTime = null;
  static TimeOfDay? endingTime = null;

  var seriesList;
  var animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData(String _location,
      DateTime? _pickedDate, TimeOfDay? _startingTime, TimeOfDay? _endingTime)  {
    location = _location;
    pickedDate = _pickedDate;
    startingTime = _startingTime;
    endingTime = _endingTime;
    var data = _createSampleData();
    List<weatherWithTime> _data = data as List<weatherWithTime> ;
    return new SimpleTimeSeriesChart(
      _data,
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(zeroBound: false)),
      behaviors: [
        charts.LinePointHighlighter(
          drawFollowLinesAcrossChart: true,
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static Future<List<charts.Series<weatherWithTime, DateTime>>>
      _createSampleData() async {


    // final data = [
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 07:00:00'), 28),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 08:00:00'), null),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 09:00:00'), 23),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 10:00:00'), 45),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 11:00:00'), null),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 13:00:00'), 19),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 14:00:00'), 29),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 15:00:00'), 45),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 16:00:00'), 39),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 17:00:00'), 12),
    //   weatherWithTime(
    //       DateTime.parse('2020-09-08 18:00:00'), 32),
    //
    // ];

    var data = await RTDB.fetchData(location,
        pickedDate!, startingTime!, endingTime!) as List<weatherWithTime>;

    return [
      new charts.Series<weatherWithTime, DateTime>(
        id: 'weatherWithTime',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (weatherWithTime currData, _) =>
            DateTime.parse(RTDB.pickedDateAsString + ' ' + currData.time),
        measureFn: (weatherWithTime currData, _) =>
            double.parse(currData.temperature),
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
// class weatherWithTime {
//   final DateTime time;
//   final double? temperature;
//
//   weatherWithTime(this.time, this.temperature);
// }
