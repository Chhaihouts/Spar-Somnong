import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/presentations/app.dart';
import 'package:flutter_kickstart/presentations/screen/edit_profile_screen.dart';
import 'package:flutter_kickstart/presentations/screen/favorite_screen.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/service/google/google_service.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var appConfig = Config.fromJson(config);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    return Consumer<UserProvider>(builder: (context, data, _) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBarWidget.buildAppBar(context),
          backgroundColor: Color(0xffF4F4F4),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: (data != null && data.user != null &&
                                  data.user.photo != null)
                                  ? CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(data.user.photo
                                    .trimLeft()
                                    .substring(0, 5)
                                    .contains("https")
                                    ? "${data.user.photo}"
                                    : "${appConfig.baseUrl}/${data.user.photo}"),
                              )
                                  : CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                AssetImage("assets/images/logo.png"),
                              )),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data.user.name ?? "Username",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  data.user.email ?? "phone number",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  data.user.phone ?? "",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  data.user.position != null
                                      ? data.user.position.name_en
                                      : "",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
//                          mainAxisAlignment:  MainAxisAlignment.start,
//                          textBaseline: TextBaseline.alphabetic,
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
//              Card(
//                child: Padding(
//                  padding: EdgeInsets.all(10.0),
                Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Material(
                        child: InkWell(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(languageConfig
                                    .text("edit_profile")),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                )
                              ],
                            ),
                            height: 40,
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen()),
                            );
                          },
                        ),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 2, right: 5, left: 5),
                    ),
                    Container(
                      height: 50,
                      child: Material(
                        child: InkWell(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  languageConfig.text("favorites"),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                )
                              ],
                            ),
                            height: 40,
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoriteScreen()),
                            );
                          },
                        ),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(left: 5, right: 5),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              languageConfig.text("log_out"),
                              style: (TextStyle(color: Colors.white)),
                            ),
                          ),
                          onPressed: () {
                            logout();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    googleSignIn.disconnect();
    Provider.of<UserProvider>(context, listen: false).clear();
//    Navigator.pushNamed(context, "/main");
    Route route = MaterialPageRoute(builder: (context) => MainPage());
    Navigator.pushReplacement(context, route);
  }
}
