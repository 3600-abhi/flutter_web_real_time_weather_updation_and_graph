import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class graphDemo extends StatelessWidget {
   graphDemo({Key? key}) : super(key: key);

  List<SalesData> list = [];

  Future<List<SalesData>> getList() async {
    list.add(SalesData(year: '2000', sales: '20000'));
    list.add(SalesData(year: '2001', sales: '50000'));
    list.add(SalesData(year: '2002', sales: '30000'));
    list.add(SalesData(year: '2003', sales: '45000'));
    list.add(SalesData(year: '2004', sales: '88000'));
    list.add(SalesData(year: '2005', sales: '65000'));
    list.add(SalesData(year: '2006', sales: '90000'));
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Graph Demo')),
      body: SafeArea(
        child: FutureBuilder(
          future: getList(),
          builder: (context,snapshot) {
            if(snapshot.hasData){
              return Center(
                child: Container(
                  height: 600,
                  width: 600,
                  child: SfCartesianChart(
                    primaryYAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                      series: <ChartSeries<SalesData, int>>[
                        LineSeries<SalesData, int>(
                          dataSource: list,
                          xValueMapper: (SalesData currentData, _) => int.parse(currentData.year),
                          yValueMapper: (SalesData currentData, _) =>
                              double.parse(currentData.sales),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ]
                  ),
                ),
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}


class SalesData {
  String year;
  String sales;
  SalesData({required this.year,required this.sales});
}