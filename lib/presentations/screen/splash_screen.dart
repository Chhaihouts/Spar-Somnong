import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/service/user_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<ConnectivityResult> subscription;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  IdTokenResult tokenResult;
  Timer timer;
  Flushbar flushBar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var connection = await Connectivity().checkConnectivity();
      if (connection != ConnectivityResult.none) {
        timer = Timer.periodic(Duration(seconds: 2), (newTimer) async {
          timer.cancel();
          startCheckUser();
        });
      } else {
        _showSnackBar(context);
        timer = Timer.periodic(Duration(seconds: 4), (newTimer) async {
          connection = await Connectivity().checkConnectivity();
          if (connection != ConnectivityResult.none) {
            timer.cancel();
            startCheckUser();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    _scaffoldKey = null;
    timer?.cancel();
    super.dispose();
  }

  startCheckUser() async {
    var currency = await getCurrency();
    if (currency != null) {
      Provider.of<UserProvider>(context, listen: false).setCurrency(
          currency);
      LanguageWrapper.updateCurrency(context, DOLLAR_CURRENCY);
    }
    try {
      var authResult = await FirebaseAuth.instance.currentUser();
      if (authResult != null) {
        var tokenResult = await authResult.getIdToken(refresh: true);
        try {
          var userResult = await getUser(tokenResult.token);
          if (userResult != null) {
            var user = userResult;
            user.token = tokenResult.token;
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            startTime(1);
          } else {
            startTime(2);
          }
        } catch (err) {
          startTime(2);
        }
      } else {
        startTime(3);
      }
    } catch (error) {
      print("error in catch $error");
    }
  }

  startTime(int val) {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage(context));
  }

  navigationPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/main");
  }

  void _showSnackBar(BuildContext context) {
    flushBar = Flushbar(
      backgroundColor: Color(0xff002D45),
      duration: Duration(hours: 1),
      message: "No Internet Connection",
      mainButton: FlatButton(
        onPressed: () {},
        child: Text(
          "Try again",
          style: TextStyle(color: Color(0xff00C669)),
        ),
      ),
    );
    flushBar.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(color: Colors.white),
          child: new Container(
            margin: new EdgeInsets.all(30.0),
            width: 250.0,
            height: 250.0,
            child: new Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
