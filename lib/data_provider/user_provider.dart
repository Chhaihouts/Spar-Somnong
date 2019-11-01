import 'package:flutter/cupertino.dart';
import 'package:flutter_kickstart/model/currency_model.dart';
import 'package:flutter_kickstart/model/user.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  UserModel get user => _user;
  Map<String,CurrencyModel> currencyModel;
  String currencyKey;

  set user(UserModel user) {
    _user = user;
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
  }

  UserModel getUser() {
    return user;
  }

  void setCurrency(Map<String,CurrencyModel> currencyModel) {
    this.currencyModel = currencyModel;
    notifyListeners();
  }

  Map<String,CurrencyModel> getCurrency() {
    return currencyModel;
  }

  void clearCurrency() {
    this.currencyModel.clear();
    notifyListeners();
  }

  set setCurrencyKey(String value) {
    this.currencyKey = value;
    notifyListeners();
  }
   String getCurrencyKey() => this.currencyKey;
}
