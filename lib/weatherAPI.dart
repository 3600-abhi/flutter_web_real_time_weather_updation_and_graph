import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';

class weatherAPI {
  static String apiKey = 'd56eb9af33f2e453687a7ed57ba39269';

  static Future<weatherWithTime?> getWeather(String location) async {
    // get the weather data from the weather map API
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey');
    var response = await get(url);
    Map data = jsonDecode(response.body);

    //  get temperature and humidity
    String temperature =
        (data['main']['temp'] - 273.15).toString().substring(0, 5);
    String humidity = data['main']['humidity'].toString();

    DateTime currentDateTime = DateTime.now();
    String formattedTime = DateFormat.Hms().format(currentDateTime);
    String currentTime = formattedTime;

    weatherWithTime weatherData = weatherWithTime(
        time: currentTime, temperature: temperature, humidity: humidity);

    // print(
    //     'Hello Abhishek temperature is ${weatherData.temperature} and humidity is ${weatherData.humidity} '
    //         'at time = ${weatherData.time}');

    return weatherData;
  }

  static Future<List<String>> getCities({String? query}) async {
    final limit = 3;

    var url = Uri.parse(
        'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$apiKey');
    var response = await get(url);
    var data = jsonDecode(response.body) as List;

    return data.map((json) {
      String city = json['name'];
      String country = json['country'];
      return '$city, $country';
    }).toList();
  }
}
