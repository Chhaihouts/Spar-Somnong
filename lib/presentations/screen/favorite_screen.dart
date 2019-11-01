import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/favourite_model.dart';
import 'package:flutter_kickstart/presentations/screen/product_detail_screen.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:flutter_kickstart/service/product/favourite_service.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin {
  SnackBar snackBar;
  StreamSubscription<ConnectivityResult> subscription;
  List<Favourite> favourites;
  StreamController _favouriteStreamBuilder = BehaviorSubject<List<Favourite>>();
  var appConfig = Config.fromJson(config);

  Flushbar _flushBar;
  int page = 1;
  int limit = 15;

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showSnackBar(LanguageWrapper.of(context).text("no_internet_connection"));
      } else {
        startTime();
      }
    });

    getFavouriteClient(page, limit).then((data) {
      _favouriteStreamBuilder.add(data);
      setState(() {
        favourites = data;
      });
    }).catchError((onError) {
      _showSnackBar(LanguageWrapper.of(context).text("error_getting_data"));
    }).timeout(Duration(seconds: 10), onTimeout: _onTimeOut);
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    _favouriteStreamBuilder.close();
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    _flushBar = Flushbar(
      backgroundColor: Color(0xff002D45),
      message: message,
      duration: Duration(seconds: 3),
    );
    _flushBar.show(context);
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
//    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return Scaffold(
        appBar: AppBarWidget.buildAppBar(context),
        backgroundColor: Colors.white,
        body: Container(
          child: StreamBuilder<List<Favourite>>(
            stream: Stream.value(favourites),
            builder: (BuildContext context,
                AsyncSnapshot<List<Favourite>> snapshot) {
              return (snapshot.data != null &&
                      snapshot.hasData &&
                      !snapshot.hasError)
                  ? snapshot.data.length > 0
                      ? Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 5),
                                  child: Text(
                                    "All Categories",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xffA8A8A8), fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                child: ListView.builder(
                                    controller: _controller,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
//                                      return makeCard(snapshot.data, index);
                                      print("image ${snapshot.data[index]
                                          .item_img}");
                                      return MyItem(snapshot.data[index],
                                          onDelete: () => openAlertBox(
                                              languageConfig,
                                              context,
                                              index,
                                              snapshot.data[index]));
                                    }),
                                onRefresh: _refresh,
                              ),
                            )
                          ],
                        )
                      : EmptyData()
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ));
  }

  _onTimeOut() {
    _showSnackBar(LanguageWrapper.of(context).text("getting_data_so_long"));
  }

  // ignore: missing_return
  Future<void> _refresh() async {
    var categoriesList = await getFavouriteClient(page, limit);
    _favouriteStreamBuilder.add(categoriesList);
  }


  openAlertBox(LanguageConfig languageConfig, BuildContext context, int index,
      Favourite favourite) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(
                          languageConfig.text("do_you_want_to_remove"),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 10.0, top: 10.0, left: 15.0),
                        child: Row(
                          children: <Widget>[
                            Card(
                              margin: EdgeInsets.only(
                                  left: 0, top: 4.0, right: 4.0, bottom: 4.0),
                              color: Colors.white,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                padding: EdgeInsets.all(5),
                                child: FadeInImage(
                                  width: 65,
                                  height: 65,
                                  image: favourite.item_img != null
                                      ? NetworkImage(appConfig.baseUrl + "/" +
                                      favourite.item_img)
                                      : AssetImage(
                                      "assets/images/facebook.png"),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.png"),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  favourite.name_en,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  " \$ 100/ Ton",
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(4.0)),
                                ),
                                child: Text(
                                  languageConfig.text("cancel"),
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              splashColor: Colors.red,
                              onTap: () {
                                deleteFavourite(favourite.id).then((data) {
                                  if (data.message == "success") {
                                    setState(() {
                                      favourites.removeAt(index);
                                    });
                                    _showSnackBar(
                                        "${favourite.name_en} has been deleted.");
                                    _favouriteStreamBuilder.add(favourites);
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(4.0)),
                                ),
                                child: Text(
                                  languageConfig.text("remove"),
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page++;
      });

      getFavouriteClient(page, limit).then((data) {
        _favouriteStreamBuilder.add(data);
        setState(() {
          favourites.addAll(data);
        });
      }).catchError((onError) {
        _showSnackBar("Error getting data");
      }).timeout(Duration(seconds: 10), onTimeout: _onTimeOut);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class MyItem extends StatelessWidget {
  final Favourite favourite;
  final VoidCallback onDelete;

  MyItem(this.favourite, {this.onDelete});

  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return Column(
      children: <Widget>[
        Container(
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(color: Color(0xfaf7f7)),
                  child: Row(
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.only(
                            left: 0, top: 4.0, right: 4.0, bottom: 4.0),
                        color: Colors.white,
                        elevation: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: FadeInImage(
                            width: 66,
                            height: 66,
                            image: favourite.item_img != null
                                ? NetworkImage(
                                appConfig.baseUrl + "/" + favourite.item_img)
                                : AssetImage("assets/images/placeholder.png"),
                            placeholder:
                                AssetImage("assets/images/placeholder.png"),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            favourite.name_en,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            softWrap: true,
                            maxLines: 2,
                          ),
                          Text(
                            " \$ 100/ Ton",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: IconButton(
                    onPressed: this.onDelete,
                    icon: Image.asset(
                      "assets/icons/delete.png",
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                          favourite.id,
                          languageConfig.getTextByKey(
                              favourite.toJson(), "name"))));
            },
          ),
        ),
        Divider(
          height: 1,
          indent: 15,
          endIndent: 15,
        )
      ],
    );
  }
}
