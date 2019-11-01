import 'package:flutter/cupertino.dart';

class Language with ChangeNotifier {
  int _language = 1;

  int get language => _language;

  set language(int value) {
    _language = value;
  }

  void changeToEn() {
    _language = 1;
    notifyListeners();
  }

  void changeToKm() {
    _language = 2;
    notifyListeners();
  }
}
