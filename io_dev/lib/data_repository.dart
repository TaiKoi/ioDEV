// import 'package:http/http.dart' as http;
// import 'package:io_dev/models/db-data-model.dart';
// import 'dart:convert';
// import 'models/db-data-model.dart';

// Future<Stream<DbData>> getData() async {
//   final String url = 'https://tktestapi.azurewebsites.net/api/values';

//   final client = new http.Client();
//   final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

//   return streamedRest.stream
//       .transform(utf8.decoder)
//       .transform(json.decoder)
//       .expand((data) => (data as List))
//       .map((data) => DbData.fromJSON(data));
// }
