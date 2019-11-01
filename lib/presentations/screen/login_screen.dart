import 'dart:async';
import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:flutter_kickstart/presentations/widget/facebook_login_button.dart';
import 'package:flutter_kickstart/presentations/widget/google_login_button.dart';
import 'package:flutter_kickstart/service/facebook_service.dart';
import 'package:flutter_kickstart/service/google/google_service.dart';
import 'package:flutter_kickstart/service/user_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum Method {
  google,
  facebook,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ChangeNotifier {

  StreamSubscription<ConnectivityResult> subscription;
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController smsCodeController = new TextEditingController();
  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var isWait = StreamController<bool>();
  var userStream = BehaviorSubject<UserModel>();

  bool _validate = false;
  bool isEnable = false;
  bool isLoading = false;
  bool isLoggedIn = false;
  bool isSent = false;
  int _start = 30;
  String phoneNo;
  String smsCode;
  String verificationId;
  String facebookToken;
  UserModel user;
  Flushbar flushBar;
  Timer _timer;


  Future<void> verifyNumber() async {
    isWait.add(true);
    startTimer();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {};

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;

      setState(() {
        this.isEnable = true;
        this.isSent = true;
      });
    };

    final PhoneVerificationFailed verificationFailed = (AuthException exception) {
      setState(() {
        this.isEnable = false;
        this.isSent = false;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+855" + phoneNumberController.text,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 15),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed);
  }

  signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      var credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsCodeController.text);
      try {
        var authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
        var tokenResult = await authResult.user.getIdToken(refresh: true);

        _getUserByToken(tokenResult.token);
      } catch (e) {
        _showSnackBar("Invalid Code");
        setState(() {
          isLoading = false;
          isEnable = true;
        });
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  // Countdown timer request verify code
  void startTimer() {
    _timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) =>
          setState(
                () {
              if (_start < 1) {
                timer.cancel();
              } else {
                _start = _start - 1;
                if (_start == 0) {
                  timer.cancel();
                  _start = 30;
                  isWait.add(false);
                }
              }
            },
          ),
    );
  }

  void initiateFacebookLogin() async {
    setState(() {
      isLoading = true;
    });
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("error facebook");
        setState(() {
          isLoading = false;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("error cancel");
        setState(() {
          isLoading = false;
        });
        break;
      case FacebookLoginStatus.loggedIn:
        print("error login ");
        var accessToken = facebookLoginResult.accessToken.token;
        var facebookAuth =
        FacebookAuthProvider.getCredential(accessToken: accessToken);
        var authResult =
        await FirebaseAuth.instance.signInWithCredential(facebookAuth);
        authResult.user.getIdToken(refresh: true).then((IdTokenResult onValue) {
          facebookToken = onValue.token;
          _getUserByToken(facebookToken);
        });
        break;
    }
  }

  @override
  void dispose() {
    userStream.close();
    phoneNumberController.dispose();
    smsCodeController.dispose();
    subscription.cancel();
    isWait.close();
    _timer.cancel();
    _textEditingController.clear();
    super.dispose();
  }

  // Widget for countdown time
  Widget countDown() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 22, 0, 0),
      child: Text(
        '($_start)',
        style: TextStyle(color: Colors.green, fontSize: 18),
      ),
    );
  }

  @override
  void initState() {
    isWait.add(false);
//    _scaffoldKey = null;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print(result);
        setState(() {
          isLoading = false;
        });
        _showSnackBar(
            LanguageWrapper.of(context).text("no_internet_connection"));
      } else {
        print(result);
        //startTime();
      }
    });
    super.initState();
  }

  _getUserByToken(String token) async {
    var authResult = await FirebaseAuth.instance.currentUser();
    if (authResult != null) {
      try {
        var userResult = await getUser(token);
        if (userResult != null) {
          var user = userResult;
          user.token = token;
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          setState(() {
            isLoggedIn = true;
            isLoading = false;
          });
          //_textEditingController.text = token;
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed("/signup");
        }
      } catch (err) {
        print("run in catch $err");
        await FirebaseAuth.instance.signOut();
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String msg) {
    flushBar = Flushbar(
      backgroundColor: Color(0xff002D45),
      message: msg,
      duration: Duration(seconds: 3),
    );
    flushBar.show(context);
  }

  _googleButtonClick() async {
    try {
      await signInWithGoogle();
      setState(() {
        isLoading = true;
      });
      _getUserByToken(googleToken);
    } catch (err) {
      print("google login error $err");
      setState(() {
        isLoading = false;
      });
    }
  }

  _facebookButtonClick() {
    initiateFacebookLogin();
  }

  signUp(BuildContext context, AuthResult authResult, String token) async {
    var ph = phoneNumberController.text;
    var uid = authResult.user.uid;
//      var phone = phoneNumberController.text;
    if (phoneNumberController.text.indexOf("0") == 0) {
      var p = phoneNumberController.text.substring(1);
      ph = "+855" + p;
    } else {
      ph = "+855" + phoneNumberController.text;
    }

    FormData formData;
    formData = FormData.fromMap({
      "phone": ph,
      "uid": uid
    });

    var response = await Dio()
        .post("${appConfig.baseUrl}/api/auth/signup", data: formData);
    print(response.data);
    var json = response.data;
    UserResponse userResponse = UserResponse.fromJson(json);
    if (userResponse.message == "success") {
      setState(() {
        isLoading = false;
      });
      userResponse.data.token = token;
      Provider.of<UserProvider>(context, listen: false)
          .setUser(userResponse.data);
      Navigator.of(context).pop();

    } else if (!userResponse.success) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(userResponse.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    _displayLoginForm() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Form(
              key: _formKey,
              autovalidate: _validate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      LanguageWrapper.of(context).text("welcome"),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 30),
                    child: Text(
                      LanguageWrapper.of(context).text("sign_in_to_con"),
                      style: TextStyle(color: Color(0xff929292)),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              this.phoneNo = value;
                            },
                            controller: phoneNumberController,
                            validator: validateMobile,
                            decoration: InputDecoration(
                                labelText: LanguageWrapper.of(context)
                                    .text("phone_number"),
                                prefixText: '+855  ',
                                suffixIcon: StreamBuilder(
                                    stream: isWait.stream,
                                    builder: (context,
                                        AsyncSnapshot<bool> snapshot) {
                                      if (snapshot.data != null) {
                                        if (snapshot.data == false) {
                                          return Container(
                                            child: IconButton(
                                              icon: new Image.asset(
                                                  'assets/images/ic_send_verifi.png'),
                                              iconSize: 28,
                                              onPressed: () => {
                                                (phoneNumberController
                                                    .text.isNotEmpty)
                                                    ? verifyNumber()
                                                    : _formKey.currentState
                                                    .validate()
                                              },
                                            ),
                                          );
                                        }
                                      }
                                      return countDown();
                                    })),
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          isSent ? TextFormField(
                            enabled: isEnable ? true : false,
                            cursorColor: Colors.green,
                            onChanged: (value) {
                              this.smsCode = value;
                            },
                            controller: smsCodeController,
                            decoration: InputDecoration(
                              focusColor: Colors.green,
                              fillColor: Colors.green,
                              labelText: LanguageWrapper.of(context).text("verification_code"),
                              hoverColor: Colors.green,
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18),
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(6),
                            ],
                          ) : Container(height: 0,),
                          isSent ? Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: new FlatButton(
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  languageConfig.text("sign_in"),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              onPressed: () => smsCodeController.text.isNotEmpty
                                  ? signIn(context)
                                  : Flushbar(
                                message: LanguageWrapper.of(context).text(
                                    "please_choose_your_profile"),
                                duration: Duration(seconds: 3),
                              )
                                ..show(context),
                            ),
//                                      )
                          ) : Container(height: 0,),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 100, right: 5),
                    child: Divider(
                      color: Color(0xff929292),
                      height: 36,
                    )),
              ),
              Text("OR"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 5, right: 100),
                    child: Divider(
                      color: Color(0xff929292),
                      height: 36,
                    )),
              ),
            ]),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: new FacebookLoginButton(
              onPress: () => {_facebookButtonClick()},
              social: "facebook",
              icon: "assets/images/facebook_logo.png",
              title: 'Sign In with Facebook',
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new GoogleLoginButton(
              onPress: () => {_googleButtonClick()},
              social: "google",
              icon: "assets/images/gmail_logo.png",
              title: 'Sign In with Google',
            ),
          ),
//          TextField(
//            controller: _textEditingController,
//          )
        ],
      );
    }

    return Consumer<UserProvider>(builder: (context, data, _) {
      return Scaffold(
          backgroundColor: Color(0xffF4F4F4),
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: new IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: new SingleChildScrollView(
                  child: new Container(
                      child: MergeSemantics(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Builder(
                                builder: (BuildContext context) {
                                  return _displayLoginForm();
                                },
                              ))))),
            ),
          ));
    });
  }

  String validateMobile(String value) {
    if (value.length < 8)
      return LanguageWrapper.of(context).text("invalid_phone_number");
    else
      return null;
  }

  String validateVerification(String value) {
    if (value.length < 6)
      return LanguageWrapper.of(context).text("invalid_code");
    else
      return null;
  }
}
