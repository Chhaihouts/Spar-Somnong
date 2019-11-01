import 'dart:async';

import 'package:badges/badges.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/category_model.dart';
import 'package:flutter_kickstart/presentations/screen/category_screen.dart';
import 'package:flutter_kickstart/presentations/screen/favorite_screen.dart';
import 'package:flutter_kickstart/presentations/screen/message_screen.dart';
import 'package:flutter_kickstart/presentations/screen/more_category_screen.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/product/product_list_widget.dart';
import 'package:flutter_kickstart/service/product/category_services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<Category> categories;
  String status = "status";
  String language = "en";

  StreamSubscription<ConnectivityResult> subscription;
  GlobalKey<ScaffoldState> _scaffoldKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  StreamController streamController;
  Flushbar flushbar;

  bool isTimeout = false;

  final toolbar = Row(
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Container(
          child: Image.asset("assets/images/logo.png",
              width: 96.74, height: 25.12),
        ),
      )
    ],
  );

  Widget tabNavigation() => Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(
                height: 1,
              ),
              Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 30,
                            height: 30,
                            child: IconButton(
                                icon: Image.asset("assets/icons/category.png"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryScreen()));
                                }),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: IconButton(
                                icon: Image.asset("assets/icons/favourite.png"),
                                onPressed: () {
                                  var isLoggedIn = Provider.of<UserProvider>(
                                          context,
                                          listen: false)
                                      .getUser();
                                  (isLoggedIn == null)
                                      ? Navigator.of(context)
                                          .pushNamed("/login")
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FavoriteScreen()));
                                }),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                            flex: 1,
                            child: Selector<ChatProvider, bool>(
                              selector: (_, ChatProvider chatProvider) =>
                                  chatProvider.hasSeenAll,
                              builder: (_, bool hasSeenAll, __) {
                                print("$hasSeenAll has Chat now");
                                return Container(
                                  child: IconButton(
                                      icon: Badge(
                                        badgeContent: Text(""),
                                        shape: BadgeShape.circle,
                                        showBadge: !hasSeenAll,
                                        child: Image.asset(
                                            "assets/icons/chat.png"),
                                      ),
                                      onPressed: () {
                                        var isLoggedIn =
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .getUser();
                                        (isLoggedIn == null)
                                            ? Navigator.of(context)
                                                .pushNamed("/login")
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageScreen()));
                                      }),
                                );
                              },
                            )),
                        VerticalDivider(),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: IconButton(
                                icon: Image.asset("assets/icons/po.png"),
                                onPressed: () {
                                  print("Chat");
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height: 54,
              )
            ],
          )
        ],
      );

  @override
  void dispose() {
    streamController.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey = new GlobalKey<ScaffoldState>();
      _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
      streamController = BehaviorSubject<List<Category>>();
      categoriesClient(1, 9).then((data) {
        streamController.add(data);
        setState(() {
          categories = data;
        });
      }).catchError((onError) {
        print("error ${onError.toString()}");
      }).timeout(Duration(seconds: 10));
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          _showSnackBar();
        } else {
          flushbar?.dismiss(true);
        }
      });
    });
  }

  void _showSnackBar() {
    flushbar = Flushbar(
      backgroundColor: Color(0xff002D45),
      message: "No Internet Connection",
      mainButton: FlatButton(
        onPressed: () {},
        child: Text(
          "Try again",
          style: TextStyle(color: Color(0xff00C669)),
        ),
      ),
    );
    flushbar.show(context);
  }

  // ignore: missing_return
  Future<void> _refresh() async {
    setState(() {
      categories = null;
    });
    var categoriesList = await categoriesClient(1, 9);
    setState(() {
      categories = categoriesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBarWidget.buildAppBar(context),
          backgroundColor: Color(0xffF4F4F4),
          key: _scaffoldKey,
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Card(
                      elevation: 2.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      child: Container(
                          decoration: BoxDecoration(color: Colors.white30),
                          child: tabNavigation()),
                    ),
                  ),
                  Expanded(child: Builder(
                    builder: (BuildContext context) {
                      return (categories != null)
                          ? Container(
                              child: StreamBuilder<List<Category>>(
                                stream: Stream.value(categories),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Category>> snapshot) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: ListView.builder(
                                        addAutomaticKeepAlives: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: categories.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return mainCategory(
                                              languageConfig, index);
                                        }),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ))
                ],
              ),
            ),
          )),
    );
  }

  mainCategory(LanguageConfig languageConfig, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.00, left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      languageConfig.getTextByKey(
                          categories[index].toJson(), "name"),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MoreCategoryScreen(categories[index])));
                    },
                    child: Text(
                      LanguageWrapper.of(context).text("more"),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          Container(
            height: 200,
            child: Builder(
              builder: (context) {
                return ProductListWidget(categories[index].id);
              },
            ),
          )
        ],
      ),
    );
  }
}
