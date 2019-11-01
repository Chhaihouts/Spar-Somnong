import 'package:flutter/foundation.dart';

class MethodLogin with ChangeNotifier{
  String methodLogin;

  String get methodLg => methodLogin;

  set methodLg(String ml) {
    methodLogin = ml;
  }

  void setMethodLogin(String ml) {
    methodLogin = ml;
    notifyListeners();
  }
}