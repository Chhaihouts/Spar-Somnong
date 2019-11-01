
import 'dart:convert';

import 'package:flutter_kickstart/model/place_holder_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

readLanguageFromSharePreference() async {
  final prefs = await SharedPreferences.getInstance();
  final key = "language";
  final value = prefs.getString(key) ?? "en";
  return value.toString();
}

saveLanguageToSharePreference(String language) async {
  final prefs = await SharedPreferences.getInstance();
  final key = "language";
  final value = language;
  prefs.setString(key, value);
}
