import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data/localDatabase/share_preference.dart';
import 'package:flutter_kickstart/language_wrapper.dart';

class FlagLanguage extends StatefulWidget {
  @override
  _FlagLanguageState createState() => _FlagLanguageState();
}

class _FlagLanguageState extends State<FlagLanguage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 4, 0),
            child: new SizedBox(
                height: 25.0,
                width: 28.0,
                child: new IconButton(
                  padding: new EdgeInsets.all(0.0),
                  icon: Image.asset('assets/images/km.png'),
                  onPressed: (){
                    changeToKm("km");
                  }
                )
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: new SizedBox(
                height: 25.0,
                width: 28.0,
                child: new IconButton(
                    padding: new EdgeInsets.all(0.0),
                    icon: Image.asset('assets/images/en.png'),
                    onPressed: (){
                      changeToKm("en");
                    }
                )
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: new SizedBox(
                height: 25.0,
                width: 28.0,
                child: new IconButton(
                    padding: new EdgeInsets.all(0.0),
                    icon: Image.asset('assets/images/zh.png'),
                    onPressed: (){
                      changeToKm("zh");
                    }
                )
            ),
          ),
        ],
      ),
    );
  }

  changeToEn(String language) {
    saveLanguageToSharePreference("en");
    LanguageWrapper.updateLocale(context, language);
  }

  changeToKm(String language) {
    saveLanguageToSharePreference("km");
    LanguageWrapper.updateLocale(context, language);
  }

  changeToZh(String language) {
    saveLanguageToSharePreference("zh");
    LanguageWrapper.updateLocale(context, language);
  }
}
