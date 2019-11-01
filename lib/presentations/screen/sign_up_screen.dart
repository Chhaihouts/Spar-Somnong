import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:flutter_kickstart/presentations/widget/dropdown.dart';
import 'package:flutter_kickstart/service/google/google_service.dart';
import 'package:flutter_kickstart/service/product/category_services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../language_wrapper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  File _image;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController positionController = new TextEditingController();
  var photoStream = BehaviorSubject<String>();
  GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  bool _fromGoogle = false;
  bool _fromPhone = false;
  bool _isLoading = false;

  String photoUrl = "";
  String email = "";
  String name = "";
  String uid = "";
  int positionId;
  String phoneNum;

  @override
  void initState() {
    getDataFromFirebaseInstance();
    super.initState();
  }

  @override
  void dispose() {
    photoStream.close();
    usernameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    positionController.dispose();
    super.dispose();
  }

  //Open gallery
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80);
    setState(() {
      _image = File(image.path);
    });
  }

  // get email, name,... from method login
  getDataFromFirebaseInstance() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user.providerData.length < 2 && user.providerData[0] != null) {
        uid = user.uid;
        switch (user.providerData[0].providerId) {
          case "facebook.com":
            {
              if (user.providerData[0].photoUrl != null) {
                photoUrl = user.providerData[0].photoUrl;
                photoStream.add(photoUrl);
              }
              if (user.providerData[0].email != null) {
                emailController.text = user.providerData[0].email;
              }
              if (user.providerData[0].displayName != null) {
                usernameController.text = user.providerData[0].displayName;
              }
              break;
            }
          case "google.com":
            {
              _fromGoogle = true;
              if (user.providerData[0].photoUrl != null) {
                photoUrl = user.providerData[0].photoUrl;
                photoStream.add(photoUrl);
              }
              if (user.providerData[0].email != null) {
//                email = user.providerData[0].email;
                emailController.text = user.providerData[0].email;
              }
              if (user.providerData[0].displayName != null) {
//                name = user.providerData[0].displayName;
                usernameController.text = user.providerData[0].displayName;
              }
              break;
            }
          case "phone":
            {
              _fromPhone = true;
              if (user.providerData[0].phoneNumber != null) {
                phoneNum = user.providerData[0].phoneNumber;
                var p = phoneNum.substring(4);
                phoneNumberController.text = p;
              }
              break;
            }
        }
      } else {
        uid = user.uid;
        switch (user.providerData[1].providerId) {
          case "facebook.com":
            {
              if (user.providerData[1].photoUrl != null) {
                photoUrl = user.providerData[1].photoUrl;
                photoStream.add(photoUrl);
              }
              if (user.providerData[1].email != null) {
                emailController.text = user.providerData[1].email;
              }
              if (user.providerData[1].displayName != null) {
                usernameController.text = user.providerData[1].displayName;
              }
              break;
            }
          case "google.com":
            {
              _fromGoogle = true;
              if (user.providerData[1].photoUrl != null) {
                photoUrl = user.providerData[1].photoUrl;
                photoStream.add(photoUrl);
              }
              if (user.providerData[1].email != null) {
//                email = user.providerData[0].email;
                emailController.text = user.providerData[1].email;
              }
              if (user.providerData[1].displayName != null) {
//                name = user.providerData[0].displayName;
                usernameController.text = user.providerData[1].displayName;
              }
              break;
            }
          case "phone":
            {
              _fromPhone = true;
              if (user.providerData[1].phoneNumber != null) {
                phoneNum = user.providerData[1].phoneNumber;
                var p = phoneNum.substring(4);
                phoneNumberController.text = p;
              }
              break;
            }
        }
      }
    });
  }

  signUp(BuildContext context) async {
    var ph;
    if (_key.currentState.validate()) {
      _key.currentState.save();
      setState(() {
        _isLoading = true;
      });
      var name = usernameController.text;
//      var phone = phoneNumberController.text;
      if (phoneNumberController.text.indexOf("0") == 0) {
        var p = phoneNumberController.text.substring(1);
        ph = "+855" + p;
      } else {
        ph = "+855" + phoneNumberController.text;
      }
      var email = emailController.text;
      FormData formData;
      if (_image != null) {
        formData = await FormData.fromMap({
          "name": name,
          "position_id": positionId,
          "phone": ph,
          "email": email,
          "uid": uid,
          "file": MultipartFile.fromBytes(_image.readAsBytesSync(),
              filename: 'file.jpg',
              contentType: MediaType('image', 'jpg'))
        });
      } else if (_image == null && photoUrl.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(
            LanguageWrapper.of(context).text("please_choose_your_profile"));
      } else {
        formData = await FormData.fromMap({
          "photo": photoUrl,
          "name": name,
          "position_id": positionId,
          "phone": ph,
          "email": email,
          "uid": uid
        });
      }
      var response = await Dio()
          .post("${appConfig.baseUrl}/api/auth/signup", data: formData);
      print(response.data);
      var json = response.data;
      UserResponse userResponse = UserResponse.fromJson(json);
      if (userResponse.message == "success") {
        setState(() {
          _isLoading = false;
        });
        Provider.of<UserProvider>(context, listen: false)
            .setUser(userResponse.data);
        Navigator.of(context).pop();
      } else if (!userResponse.success) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(userResponse.message);
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Color(0xff002D45),
      action: SnackBarAction(
        label: 'Error',
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xffF4F4F4),
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                googleSignIn.disconnect();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: new SingleChildScrollView(
              child: new Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: Text(
                                      LanguageWrapper.of(context)
                                          .text("sign_Up"),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 0, 30),
                                    child: Text(
                                      LanguageWrapper.of(context)
                                          .text("please_upload"),
                                      style:
                                          TextStyle(color: Color(0xff929292)),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 15, 0),
                                child: GestureDetector(
                                  child: StreamBuilder(
                                    stream: photoStream.stream,
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.data != null) {
                                        if (_image == null) {
                                          return CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage:
                                                  NetworkImage(snapshot.data));
                                        } else {
                                          return CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: FileImage(_image),
                                          );
                                        }
                                      }
                                      return (_image == null)
                                          ? CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: AssetImage(
                                                  "assets/images/upload_profile.png"),
                                            )
                                          : CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage:
                                                  FileImage(_image),
                                            );
                                    },
                                  ),
                                  onTap: () {
                                    getImage();
                                  },
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 15, 20.0, 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextFormField(
                                    controller: usernameController,
                                    validator: validateName,
                                    decoration: InputDecoration(
                                      labelText: LanguageWrapper.of(context)
                                          .text("username_"),
                                    ),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 15),
                                  CountriesField(
                                    myController: positionController,
                                    validator: validatePosition,
                                    onPositionSelected: onPositionSelect,
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    controller: phoneNumberController,
                                    validator: validateMobile,
                                    readOnly: _fromPhone,
                                    decoration: InputDecoration(
                                      labelText: LanguageWrapper.of(context)
                                          .text("phone_number_"),
                                      prefixText: '+855  ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    controller: emailController,
                                    readOnly: _fromGoogle,
                                    validator: validateEmail,
                                    decoration: InputDecoration(
                                      labelText: LanguageWrapper.of(context)
                                          .text("email"),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(top: 25.0),
                                    child: new RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5)),
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          LanguageWrapper.of(context)
                                              .text("sign_in"),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Raleway',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => signUp(context),
                                    ),
//                                      )
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  void onPositionSelect(int id) {
    positionId = id;
  }

  String validateName(String value) {
    if (value.length < 3)
      return LanguageWrapper.of(context).text("name_must_be_more_than");
    else
      return null;
  }

  String validatePosition(String value) {
    if (value.length == 0)
      return LanguageWrapper.of(context).text("please_choose_position");
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return LanguageWrapper.of(context).text("enter_valid_email");
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length < 8)
      return LanguageWrapper.of(context).text("invalid_phone_number");
    else
      return null;
  }
}
