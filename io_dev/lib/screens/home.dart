import 'package:flutter/material.dart';
import 'package:io_dev/models/db-data-model.dart';

import '../data_repository.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DbData> _data = <DbData>[];

  @override
  void initState() {
    super.initState();
    listenForData();
  }

  void listenForData() async {
    final Stream<DbData> stream = await getData();
    stream.listen((DbData data) => setState(() => _data.add(data)));
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('input output'),
        ),
        body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) => DataTile(_data[index]),
        ),
      );
}
