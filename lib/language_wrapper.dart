import 'package:flutter/material.dart';

import 'languge_config.dart';

class LanguageWrapper extends StatefulWidget {

  LanguageWrapper({Key key, this.locale, this.child});

  static LanguageConfig of(BuildContext context) {
    final LanguageConfig languageConfig =
    context.inheritFromWidgetOfExactType(LanguageConfig);
    return languageConfig;
  }

  static updateLocale(BuildContext context, String locale) async {
    _LanguageWrapperState state = context.ancestorStateOfType(const TypeMatcher<_LanguageWrapperState>());
    final LanguageConfig languageConfig =
    context.inheritFromWidgetOfExactType(LanguageConfig);
    await languageConfig.load(locale);
    state.updateLocale(locale);
  }

  static updateCurrency(BuildContext context, String currency) async {
    _LanguageWrapperState state = context.ancestorStateOfType(const TypeMatcher<_LanguageWrapperState>());
    final LanguageConfig languageConfig =
    context.inheritFromWidgetOfExactType(LanguageConfig);
    await languageConfig.loadCurrency(currency,context);
    state.updateCurrency(currency);
  }

  final String locale;
  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _LanguageWrapperState(locale,child);
  }
}

class _LanguageWrapperState extends State<LanguageWrapper>{
  String locale = 'en';
  String currency = 'dollar';
  Widget child;

  _LanguageWrapperState(this.locale, this.child);

  @override
  Widget build(BuildContext context) {
    return new LanguageConfig(locale: locale, child: child, currency: currency);
  }

  updateLocale(String locale){
    setState(() {
      this.locale = locale;
    });
  }

  updateCurrency(String currency){
    setState(() {
      this.currency = currency;
    });
  }
}