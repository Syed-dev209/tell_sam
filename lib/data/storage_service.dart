import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  Future insertData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  Future getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(key) ?? '';
    return data != '' ? jsonDecode(data) : data;
  }
}
