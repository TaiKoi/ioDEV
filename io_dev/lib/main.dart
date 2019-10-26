import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

Future<DbData> fetchData() async {
  final response =
      await http.get('https://tktestapi.azurewebsites.net/api/values');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return DbData.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to FETCH data');
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

Future<void> insertData(DbData newRow) async {
  // Get a reference to the database.
  //final DbData db = await database;
  String url = 'https://tktestapi.azurewebsites.net/api/values';
  Map<String, String> headers = {"Content-type": "application/json"};
  final postIt = await http.post(url, headers: headers, body: newRow);

  if (postIt.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return 'Data inserted into DB';
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to POST data');
  }
}

void main() => runApp(MyApp(dbData: fetchData()));

class MyApp extends StatelessWidget {
  final Future<DbData> dbData;
  final formKey = GlobalKey<FormState>();
  String _title, _length, _isTrue;

  MyApp({Key key, this.dbData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.pink,
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
                    Padding(padding: EdgeInsets.all(10)),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_forward),
                        hintText: 'Enter Title',
                        labelText: 'Title',
                      ),
                      onSaved: (String titleInput) {
                        _title = titleInput;
                      },
                      validator: (titleInput) {
                        return titleInput.contains(
                                '') //can only contain letter characters!
                            ? 'Only enter letters!'
                            : null;
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.arrow_forward),
                          hintText: 'Enter Duration',
                          labelText: 'Length',
                        ),
                        onSaved: (String lengthInput) {
                          _length = lengthInput;
                        },
                        validator: (lengthInput) {
                          return lengthInput.contains(
                                  '') //can only contain numerical values!
                              ? 'Only enter numbers!'
                              : null;
                        }),
                    TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.arrow_forward),
                          hintText: 'Enter true or false',
                          labelText: 'true or false?',
                        ),
                        onSaved: (isTrueInput) {
                          _isTrue = isTrueInput;
                        },
                        validator: (isTrueInput) {
                          return isTrueInput.contains(
                                  '') //can only contain true or false!
                              ? 'Only enter True or False'
                              : null;
                        }),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(240, 0, 0, 0)),
                      RaisedButton(
                          onPressed: () async {
                            await _submit();
                          },
                          child: Text('Save to Database'))
                    ]),
                    Padding(padding: EdgeInsets.all(50)),
                    RaisedButton(
                      color: Colors.lightGreen,
                      child: Text(snapshot.data.title),
                      onPressed: () {},
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(42, 10, 42, 10),
                        color: Colors.pink,
                        child: Text(snapshot.data.length.toString())),
                    Container(
                        padding: EdgeInsets.fromLTRB(43, 10, 43, 10),
                        color: Colors.deepPurple,
                        child: Text(
                          snapshot.data.isTrue.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
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

  Future<void> _submit() async {
    //if (formKey.currentState.validate()) {
    formKey.currentState.save();
    print(_title);
    print(_length);
    print(_isTrue);
    DbData newRow = new DbData(
        title: _title, length: _length as double, isTrue: _isTrue as bool);
    await insertData(newRow);
    // }
  }
}
