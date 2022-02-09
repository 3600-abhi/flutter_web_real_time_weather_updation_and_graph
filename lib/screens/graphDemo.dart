import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class demoGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo Graph'),
        ),
        body: SimpleTimeSeriesChart.withSampleData(),
    );
  }
}



class SimpleTimeSeriesChart extends StatelessWidget {
   // List<charts.Series> seriesList;
   // bool? animate;

  var seriesList;
  var animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
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
  static List<charts.Series<weather, DateTime>> _createSampleData() {
    final data = [
      weather(
          DateTime.parse('2020-09-08 07:00:00'), 28),
      weather(
          DateTime.parse('2020-09-08 08:00:00'), null),
      weather(
          DateTime.parse('2020-09-08 09:00:00'), 23),
      weather(
          DateTime.parse('2020-09-08 10:00:00'), 45),
      weather(
          DateTime.parse('2020-09-08 11:00:00'), null),

      weather(
          DateTime.parse('2020-09-08 13:00:00'), 19),
      weather(
          DateTime.parse('2020-09-08 14:00:00'), 29),
      weather(
          DateTime.parse('2020-09-08 15:00:00'), 45),
      weather(
          DateTime.parse('2020-09-08 16:00:00'), 39),
      weather(
          DateTime.parse('2020-09-08 17:00:00'), 12),
      weather(
          DateTime.parse('2020-09-08 18:00:00'), 32),

    ];

    return [
        charts.Series<weather, DateTime>(
        id: 'weather',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (weather currData, _) => currData.time,
        measureFn: (weather currData, _) => currData.temperature,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class weather {
  final DateTime time;
  final double? temperature;

  weather(this.time, this.temperature);
}