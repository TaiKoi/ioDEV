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
      title: json[7]['title'],
      length: json[7]['length'],
      isTrue: json[7]['isTrue'],
    );
  }
}

Future<void> insertData(DbData newRow) async {
  // Get a reference to the database.
  //final DbData db = await database;

  String url = 'https://tktestapi.azurewebsites.net/api/values';
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, dynamic> body = {
    'title': '' + newRow.title,
    'length': newRow.length,
    'isTrue': newRow.isTrue
  };

  final postIt =
      await http.post(url, headers: headers, body: json.encode(body));

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

  TextEditingController stringController = new TextEditingController();
  TextEditingController doubleController = new TextEditingController();
  TextEditingController boolController = new TextEditingController();

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
          title: Text('Flutter --> .Net Core --> SQL DB'),
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
                      controller: stringController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_forward),
                        hintText: 'Enter Title',
                        labelText: 'Title',
                      ),
                      // onSaved: (String titleInput) {
                      //   _title = titleInput;
                      // },
                      // validator: (titleInput) {
                      //   return titleInput.contains(
                      //           '') //can only contain letter characters!
                      //       ? 'Only enter letters!'
                      //       : null;
                      // },
                    ),
                    TextFormField(
                      controller: doubleController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_forward),
                        hintText: 'Enter Duration',
                        labelText: 'Length',
                      ),
                      // onSaved: (String lengthInput) {
                      //   _length = lengthInput;
                      // },
                      // validator: (lengthInput) {
                      //   return lengthInput.contains(
                      //           '') //can only contain numerical values!
                      //       ? 'Only enter numbers!'
                      //       : null;
                      // }
                    ),
                    TextFormField(
                      controller: boolController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_forward),
                        hintText: 'Enter true or false',
                        labelText: 'true or false?',
                      ),
                      // onSaved: (isTrueInput) {
                      //   _isTrue = isTrueInput;
                      // },
                      //
                    ),
                    Row(children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(240, 0, 0, 0)),
                      RaisedButton(
                          onPressed: () async {
                            await _submit();
                          },
                          child: Text('Save to Database'))
                    ]),
                    Padding(padding: EdgeInsets.all(10)),
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
    //formKey.currentState.save();

    print('stringController: ' + stringController.text);
    print('doubleController: ' + doubleController.text);
    print('boolController: ' + boolController.text);

    DbData newRow = new DbData(
        title: stringController.text,
        length: double.parse(doubleController.text),
        isTrue: boolController.text.toLowerCase() == 'true');
    await insertData(newRow);
    // }
  }
}
