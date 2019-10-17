// import 'dart:ffi';
// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<DbData> fetchPost() async {
//   final response =
//       await http.get('https://tktestapi.azurewebsites.net/api/values');

//   if (response.statusCode == 200) {
//     // If the call to the server was successful, parse the JSON.
//     return DbData.fromJSON(json.decode(response.body));
//   } else {
//     // If that call was not successful, throw an error.
//     throw Exception('Failed to load post');
//   }
// }

// class DbData {
//   final int id;
//   final String title;
//   final Float length;
//   final bool isTrue;

//   DbData({this.id, this.title, this.length, this.isTrue});

//   factory DbData.fromJSON(Map<String, dynamic> json) {
//     return DbData(
//       id: json['id'],
//       title: json['title'],
//       length: json['length'],
//       isTrue: json['is-true'],
//     );
//   }
// }

// void main() => runApp(MyApp(dbData: fetchPost()));

// class MyApp extends StatelessWidget {
//   final Future<DbData> dbData;

//   MyApp({Key key, this.dbData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<DbData>(
//             future: dbData,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data.title);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }

//               // By default, show a loading spinner.
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
