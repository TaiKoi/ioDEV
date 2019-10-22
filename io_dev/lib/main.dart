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
    throw Exception('Failed to load data');
  }
}

class DbData {
  final String title;
  final double length;
  final bool isTrue;

  DbData({this.title, this.length, this.isTrue});

  factory DbData.fromJson(List<dynamic> json) {
    return DbData(
      title: json[2]['title'],
      length: json[2]['length'],
      isTrue: json[2]['isTrue'],
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
          title: Text('Get & Post Data Via Flutter'),
        ),
        body: Center(
          child: FutureBuilder<DbData>(
            future: dbData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    RaisedButton(
                      child: Text(snapshot.data.title),
                      onPressed: () {},
                    ),
                    Container(
                        color: Colors.pink,
                        child: Text(snapshot.data.length.toString())),
                    Text(snapshot.data.isTrue.toString()),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Enter Title',
                        labelText: 'Title',
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        return value.contains('@')
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    )
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
