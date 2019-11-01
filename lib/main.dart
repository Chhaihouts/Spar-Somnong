import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kickstart/data/localDatabase/share_preference.dart';
import 'package:flutter_kickstart/data_provider/MethodLogin.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/product_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/presentations/app.dart';
import 'package:flutter_kickstart/presentations/bottom_navigation_tab/account_tab.dart';
import 'package:flutter_kickstart/presentations/bottom_navigation_tab/home_tab.dart';
import 'package:flutter_kickstart/presentations/screen/login_screen.dart';
import 'package:flutter_kickstart/presentations/screen/sign_up_screen.dart';
import 'package:flutter_kickstart/presentations/screen/splash_screen.dart';
import 'package:flutter_kickstart/service/localization/app_translations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/constant/constant_value.dart';
import 'data_provider/language.dart';
import 'language_wrapper.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Color.fromRGBO(148, 13, 25, 1),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  String locale = await getLanguage();
  runApp(LanguageWrapper(
    child: MyApp(),
    locale: locale,
  ));
}

Future<String> getLanguage() async {
  String language = await readLanguageFromSharePreference();
  if (language == null) {
    language = 'en';
  }
  return language;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: MethodLogin()),
        ChangeNotifierProvider.value(value: Language()),
        ChangeNotifierProvider.value(value: ChatProvider()),
        ChangeNotifierProvider.value(value: ProductProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
//        home: Home(),
          initialRoute: '/',
          routes: {
            "/": (context) => SplashScreen(),
            "/main": (context) => MainPage(),
            "/home": (context) => Home(),
            '/login': (context) => LoginScreen(),
            "/account": (context) => AccountScreen(),
            "/signup": (context) => SignUpScreen(),
          },
          localizationsDelegates: [
            const AppTranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Color.fromRGBO(0, 197, 105, 1),
            buttonColor: Color.fromRGBO(0, 197, 105, 1),
            highlightColor: Color.fromRGBO(172, 251, 198, 0.1),
            accentColor: Color.fromRGBO(0, 45, 69, 1),
            platform: TargetPlatform.iOS
          )),
    );
  }
}
