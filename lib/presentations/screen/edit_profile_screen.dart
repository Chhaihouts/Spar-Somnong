import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/dropdown.dart';
import 'package:flutter_kickstart/service/product/category_services.dart';
import 'package:flutter_kickstart/service/post_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import '../../language_wrapper.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var appConfig = Config.fromJson(config);
  File _image;
  TextEditingController userNameController = new TextEditingController();
  TextEditingController positionController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  String methodLogin;
  String urlPhoto;
  int positionId;
  String uid;
  String token;
  bool _fromGoogle = false, _fromPhone = false;
  String name, position, phone, email;
  bool _isLoading = false;

  @override
  void initState() {
    getLoginMethod();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LanguageConfig languageConfig = LanguageWrapper.of(context);
      UserModel user = Provider.of<UserProvider>(context, listen: false).user;

      userNameController.text = user.name != null ? user.name : "";
      positionController.text = user.position != null
          ? languageConfig.getTextByKey(user.position.toJson(), "name")
          : "";
      var p = user.phone != null ? user.phone.substring(4) : "";
      phoneController.text = p;
      emailController.text = user.email != null ? user.email : "";
      positionId = user.position_id != null ? user.position_id : "";
      urlPhoto = user.photo != null ? user.photo : "";
      uid = user.uid != null ? user.uid : "";
    });
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    positionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF4F4F4),
        appBar: AppBarWidget.buildAppBar(context),
        body: new SingleChildScrollView(
            child: new Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 3.0,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Text(
                                    LanguageWrapper.of(context)
                                        .text("edit_profile"),
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
                                  child: (_image == null)
                                      ? urlPhoto != null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(urlPhoto
                                                      .trimLeft()
                                                      .substring(0, 5)
                                                      .contains("https")
                                                  ? "$urlPhoto"
                                                  : "${appConfig.baseUrl}/$urlPhoto"),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  "assets/images/upload_profile.png"),
                                            )
                                      : CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: FileImage(_image),
                                        )),
                              onTap: () {
                                getImage();
                              },
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  controller: userNameController,
//                                  validator: (value) {
//                                    if (value.length < 3)
//                                      return LanguageWrapper.of(context)
//                                          .text("name_must_be_more_than");
//                                    else
//                                      return null;
//                                  },
                                  decoration: InputDecoration(
                                    labelText: LanguageWrapper.of(context)
                                        .text("username_"),
                                  ),
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 15),
                                CountriesField(
                                  myController: positionController,
//                                  validator: (value) {
//                                    if (value.length == 0)
//                                      return LanguageWrapper.of(context)
//                                          .text("please_choose_position");
//                                    else
//                                      return null;
//                                  },
                                  onPositionSelected: onPositionSelect,
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: phoneController,
                                  readOnly: _fromPhone,
//                                  validator: (value) {
//                                    if (value.length < 8)
//                                      return LanguageWrapper.of(context)
//                                          .text("invalid_phone_number");
//                                    else
//                                      return null;
//                                  },
                                  decoration: InputDecoration(
                                    labelText: LanguageWrapper.of(context)
                                        .text("phone_number_"),
                                    prefixText: '+885  ',
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: emailController,
                                  readOnly: _fromGoogle,
//                                  validator: (value) {
//                                    Pattern pattern =
//                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//                                    RegExp regex = new RegExp(pattern);
//                                    if (!regex.hasMatch(value))
//                                      return LanguageWrapper.of(context)
//                                          .text("enter_valid_email");
//                                    else
//                                      return null;
//                                  },
                                  decoration: InputDecoration(
                                    labelText: LanguageWrapper.of(context)
                                        .text("email"),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: 18),
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(top: 25.0),
                                  child: new FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5)),
                                    color: Theme.of(context).primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        LanguageWrapper.of(context)
                                            .text("save"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () => saveEdit(),
                                  ),
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
    );
  }

  saveEdit() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      setState(() {
        _isLoading = true;
      });
      var name = userNameController.text;
      var phone = "+855" + phoneController.text;
      if (phone.indexOf("0") == 5) {

      }
      var email = emailController.text;
      FormData formData;
      if (_image != null) {
        formData = await FormData.fromMap({
          "name": name,
          "position_id": positionId,
          "phone": phone,
          "email": email,
          "uid": uid,
          "file": MultipartFile.fromBytes(_image.readAsBytesSync(),
              filename: 'file.jpg', contentType: MediaType('image', 'jpg'))
        });
      } else {
        formData = await FormData.fromMap({
          "photo": urlPhoto,
          "name": name,
          "position_id": positionId,
          "phone": phone,
          "email": email,
          "uid": uid
        });
      }
      try {
        var response = await Dio().post("${appConfig.baseUrl}/api/auth/me",
            data: formData,
            options: Options(
              headers: {
                HttpHeaders.authorizationHeader: "Bearer $token",
                // set content-length
              },
            ));
        var json = response.data;
        UserResponse userResponse = UserResponse.fromJson(json);
        if (userResponse.message == "success") {
          setState(() {
            _isLoading = false;
          });
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userResponse.data);
          _showSnackBar(userResponse.message);
        } else if (!userResponse.success) {
          setState(() {
            _isLoading = false;
          });
          _showSnackBar(userResponse.message);
        }
      } on Exception catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(LanguageWrapper.of(context).text("something_went_wrong"));
      }
    } else {
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

  getLoginMethod() {
    FirebaseAuth.instance.currentUser().then((user) async {
      var authResult = await FirebaseAuth.instance.currentUser();
      var tokenResult = await authResult.getIdToken(refresh: true);
      token = tokenResult.token;
      if (user.providerData.length < 2 && user.providerData[0] != null) {
        switch (user.providerData[0].providerId) {
          case "google.com":
            {
              _fromGoogle = true;
              break;
            }
          case "phone":
            {
              _fromPhone = true;
              break;
            }
        }
      } else {
        switch (user.providerData[1].providerId) {
          case "google.com":
            {
              _fromGoogle = true;
              break;
            }
          case "phone":
            {
              _fromPhone = true;
              break;
            }
        }
      }
    });
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
