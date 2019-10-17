import 'dart:ffi';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

Future<DbData> fetchPost() async {
  final response =
      await http.get('https://tktestapi.azurewebsites.net/api/values');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return DbData.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class DbData {
  final int id;
  final String title;
  final double length;
  final bool isTrue;

  DbData({this.id, this.title, this.length, this.isTrue});

  factory DbData.fromJson(List<dynamic> json) {
    return DbData(
      id: json[0]['id'],
      title: json[0]['title'],
      length: json[0]['length'],
      isTrue: json[0]['is-true'],
    );
  }
}

void main() => runApp(MyApp(dbData: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<DbData> dbData;

  MyApp({Key key, this.dbData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<DbData>(
            future: dbData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return  Column(
                  children: [
                    RaisedButton(child: Text(snapshot.data.title)),
                    Text(snapshot.data.length.toString()),
                    Text(snapshot.data.id.toString()),
                    Text(snapshot.data.isTrue.toString()),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
