import 'dart:ffi';

class DbData {
  final String title;
  final Float length;
  final bool isTrue;

  DbData.fromJSON(Map<String, dynamic> jsonMap)
      : title = jsonMap['title'],
        length = jsonMap['length'],
        isTrue = jsonMap['is-true'];
}
