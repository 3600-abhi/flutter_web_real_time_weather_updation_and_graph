import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_weather_update/screens/TabularRepresentation.dart';
import 'package:real_time_weather_update/screens/tempVsTimeGraph.dart';

class dateTimePicking extends StatefulWidget {
  const dateTimePicking({Key? key}) : super(key: key);

  @override
  _dateTimePickingState createState() => _dateTimePickingState();
}

class _dateTimePickingState extends State<dateTimePicking> {
  DateTime? pickedDate = null;
  TimeOfDay? startingTime = null;
  TimeOfDay? endingTime = null;

  var optionsInsideDropdown = [
    'Graphical Representation',
    'Tabular Representation'
  ];
  var optionSelctedFromDropdown = 'Select Option';

  String getDate() {
    if (pickedDate == null) {
      return 'Select Date';
    } else {
      // print('picked date is $pickedDate');
      return '${pickedDate!.day} / ${pickedDate!.month} / ${pickedDate?.year}';
    }
  }

  String getStartingTime() {
    if (startingTime == null) {
      return 'Select Starting Time';
    } else {
      // print('starting time is $startingTime');
      var hours = startingTime!.hour.toString().padLeft(2, '0');
      var minutes = startingTime!.minute.toString().padLeft(2, '0');
      return '$hours : $minutes';
    }
  }

  String getEndingTime() {
    if (endingTime == null) {
      return 'Select Ending Time';
    } else {
      // print('ending time is $endingTime');
      String hours = endingTime!.hour.toString().padLeft(2, '0');
      String minutes = endingTime!.minute.toString().padLeft(2, '0');
      return '$hours : $minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Date and Time')),
      body: Center(
        child: Container(
          width: 550,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Date : ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  OutlinedButton(
                    child: Text(getDate(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: pickedDate ?? DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5));
                      if (newDate == null) return;
                      setState(() {
                        pickedDate = newDate;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Starting Time : ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  OutlinedButton(
                    child: Text(getStartingTime(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      TimeOfDay? newStartingTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 9, minute: 0),
                      );
                      if (newStartingTime == null) return;
                      setState(() {
                        startingTime = newStartingTime;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ending Time : ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  OutlinedButton(
                    child: Text(getEndingTime(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      TimeOfDay? newEndingTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 12, minute: 0),
                      );
                      if (newEndingTime == null) return;
                      setState(() {
                        endingTime = newEndingTime;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              DropdownButton<String>(
                hint: Text(optionSelctedFromDropdown),
                items: optionsInsideDropdown.map((option) {
                  return DropdownMenuItem(child: Text(option), value: option);
                }).toList(),
                onChanged: (newOptionSelected) {
                  setState(() {
                    optionSelctedFromDropdown = newOptionSelected as String;
                  });
                  if (pickedDate == null ||
                      startingTime == null ||
                      endingTime == null) {
                    final snackbar =
                        SnackBar(content: Text('All data are mandatory'));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (optionSelctedFromDropdown ==
                      'Graphical Representation') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureVsTimeGraph(
                                  pickedDate: pickedDate,
                                  startingTime: startingTime,
                                  endingTime: endingTime,
                                )));
                    optionSelctedFromDropdown = 'Select Option';
                  } else if (optionSelctedFromDropdown ==
                      'Tabular Representation') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabularRepresentation(
                                  pickedDate: pickedDate,
                                  startingTime: startingTime,
                                  endingTime: endingTime,
                                )));
                    optionSelctedFromDropdown = 'Select Option';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
