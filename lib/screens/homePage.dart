import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_weather_update/screens/dateTimePicking.dart';
import 'package:real_time_weather_update/screens/signIn.dart';
import 'package:real_time_weather_update/services/RTDB.dart';
import 'package:real_time_weather_update/weatherAPI.dart';
import 'package:real_time_weather_update/weatherWithTime.dart';
import 'package:real_time_weather_update/services/authentication.dart';
import 'graphDemo.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final user = FirebaseAuth.instance.currentUser;
  String location = 'New Delhi';
  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Time Weather Update'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                result = await showSearch(
                    context: context,
                    delegate: customSearchDelegate()) as String?;

                setState(() {
                  if (result == null) {
                    location = 'New Delhi';
                  } else {
                    location = result as String;
                  }
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: StreamBuilder<weatherWithTime?>(
            stream: Stream.periodic(Duration(seconds: 4)).asyncMap((i) async {
              weatherWithTime weatherData =
                  await weatherAPI.getWeather(location) as weatherWithTime;
              await RTDB.insertData(location,
                  weatherData.temperature, weatherData.humidity);
              return weatherData;
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome ${user!.email}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                      SizedBox(height: 10),
                      Text('Current Time : ${snapshot.data!.time}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 10),
                      Text(
                          'Current Temperature in $location : ${snapshot.data!.temperature}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 10),
                      Text('Current Humidity : ${snapshot.data!.humidity}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 20),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          child:
                              Text('Sign out', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            signInAuthUsingEmailAndPassword.signOutAuth().then(
                                (value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login())));
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: Text('Pick Date and Time'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => dateTimePicking(location: location)));
                          }),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: Text('See Demo Graph'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => demoGraph()));
                          }),


                      // SizedBox(height: 20),
                      // ElevatedButton(
                      //     child: Text('Graph'),
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Graph()));
                      //     })
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class customSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: weatherAPI.getCities(query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (query.isEmpty ||
            snapshot.data!.isEmpty ||
            snapshot.hasError) {
          return Center(
            child: Text('No Suggestions',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
          );
        } else {
          return buildSuggestionsSuccess(snapshot.data);
        }
      },
    );
  }

  Widget buildSuggestionsSuccess(List<String>? suggestions) {
    return ListView.builder(
      itemCount: suggestions!.length,
      itemBuilder: (context, index) {
        String suggestion = suggestions[index];
        String queryText = suggestion.substring(0, query.length);
        String remainingText = suggestion.substring(query.length);
        return ListTile(
          onTap: () {
            query = suggestion;
            // Navigator.pushReplacement(context, newRoute);
            close(context, suggestion);
            // showResults(context);
          },
          leading: Icon(Icons.location_city),
          // title: Text(suggestion),
          title: RichText(
            text: TextSpan(
                text: queryText,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                children: [
                  TextSpan(
                      text: remainingText,
                      style: TextStyle(color: Colors.grey, fontSize: 18))
                ]),
          ),
        );
      },
    );
  }
}
