// class citySearch extends SearchDelegate<String> {
//   String apiId = 'd56eb9af33f2e453687a7ed57ba39269';
//
//   Future<List<String>> searchCitiesFromAPI() async {
//     var limit = 3;
//     var url = Uri.parse(
//         'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$apiId');
//     var response = await get(url);
//     Map data = jsonDecode(response.body);
//     List<String> cityList = [];
//     cityList.add('${data['city']},  ${data['country']}');
//     return cityList;
//   }
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           if (query.isEmpty) {
//             close(context, 'result');
//           } else {
//             query = '';
//             showSuggestions(context);
//           }
//         },
//       )
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, 'result');
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return FutureBuilder(
//       future: searchCitiesFromAPI(),
//       builder: (context, snapshot) {
//         return worker();
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder(
//       future: searchCitiesFromAPI(),
//       builder: (context, snapshot) {
//         if (query.isEmpty) {
//           return buildNoSuggestions();
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return buildNoSuggestions();
//         } else {
//           return buildSuggestionsSuccess(snapshot.data);
//         }
//       },
//     );
//   }
//
//   Widget buildSuggestionsSuccess(var suggestions) {
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         String suggestion = suggestions[index];
//         String queryText = suggestion.substring(0, query.length);
//         String remainingText = suggestion.substring(query.length);
//
//         return ListTile(
//           onTap: () {
//             query = suggestion;
//             close(context, suggestion);
//             // showResults(context);
//             // Navigator.push();
//           },
//           leading: Icon(Icons.location_city),
//           title: RichText(
//               text: TextSpan(
//                   text: queryText,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                   children: [
//                 TextSpan(
//                     text: remainingText,
//                     style: TextStyle(color: Colors.grey, fontSize: 18))
//               ])),
//         );
//       },
//     );
//   }
//
//   Widget buildNoSuggestions() {
//     return Center(
//       child: Text('No Suggestions!',style: TextStyle(
//         fontSize: 30,
//         fontWeight: FontWeight.bold
//       )),
//     );
//   }
// }
