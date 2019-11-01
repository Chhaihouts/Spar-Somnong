import 'package:flutter/cupertino.dart';

enum LoginMethod { facebook, google, phone }

class LoginMethodProvider with ChangeNotifier {
  var method;

  void loginMethod(LoginMethod method) {
    switch (method) {
      case LoginMethod.phone:
        {
          method = LoginMethod.phone;
          notifyListeners();
          break;
        }
      case LoginMethod.google:
        {
          method = LoginMethod.google;
          notifyListeners();
          break;
        }
      case LoginMethod.facebook:
        {
          method = LoginMethod.facebook;
          notifyListeners();
          break;
        }
    }
  }
}
