import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/model/currency_model.dart';
import 'package:provider/provider.dart';

class LanguageConfig extends InheritedWidget {
  static Map<dynamic, dynamic> _localisedValues;
  static Map<String, CurrencyModel> _currencyValue;

  LanguageConfig(
      {Key key, @required this.locale, @required this.currency, @required Widget child})
      : assert(locale != null),
        assert(child != null),
        super(key: key, child: child) {
    if (_localisedValues == null) {
      load(locale);
    }
  }

  final String locale;
  final String currency;

  @override
  bool updateShouldNotify(LanguageConfig oldWidget) {
    return this.locale != oldWidget.locale ||
        this.currency != oldWidget.currency;
  }

  load(String locale) async {
    String jsonContent =
    await rootBundle.loadString("assets/locale/localization_$locale.json");
    _localisedValues = json.decode(jsonContent);
  }

  loadCurrency(String locale, BuildContext context) async {
    _currencyValue = Provider.of<UserProvider>(context).getCurrency();
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }

  String getTextByKey(Map<String, dynamic> map, String key) {
    var languageKey =
        "${key}_${locale == 'ch' ? 'ch' : locale == 'km' ? 'kh' : 'en'}";
    return map[languageKey] ?? "N/A";
  }

  String getCurrencyValue(double val) {
    return "${currency == '$DOLLAR_CURRENCY' ? '\$' : currency ==
        '$RIEL_CURRENCY'
        ? '៛'
        : '¥'} ${_currencyValue[currency].amount * val}";
  }
}
