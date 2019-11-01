import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/screen/product_detail_screen.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:flutter_kickstart/service/product/product_category_services.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<SearchScreen> {
  var appConfig = Config.fromJson(config);

  StreamController streamController = BehaviorSubject<List<ProductCategory>>();
  TextEditingController searchController = new TextEditingController();
  final searchOnChange = new BehaviorSubject<String>();
  StreamSubscription<ConnectivityResult> subscription;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SnackBar snackBar;
  int page = 1;
  int limit = 10;
  bool isSearching = false;
  bool isSwitch = true;

  getSearch(String query) {
    searchProduct(query, page, limit).then((product) {
      setState(() {
        isSearching = false;
      });
      streamController.add(product);
    });
  }

  _search(String queryString) {
    searchOnChange.add(queryString);
  }

  void _showSnackBar() {
    snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(LanguageWrapper.of(context).text("no_internet_connection")),
      backgroundColor: Color(0xff002D45),
      action: SnackBarAction(
        label: LanguageWrapper.of(context).text("try_again"),
        onPressed: () {
          subscription = Connectivity()
              .onConnectivityChanged
              .listen((ConnectivityResult result) {
            if (result == ConnectivityResult.none) {
              print(result);
              _showSnackBar();
            } else {
              print(result);
            }
          });
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  @override
  void initState() {
    searchOnChange.debounceTime(Duration(seconds: 1)).listen((queryString) {
      getSearch(queryString);
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showSnackBar();
      } else {
        startTime();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchOnChange.close();
    streamController.close();
    searchController.dispose();
    _scaffoldKey = null;
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Image.asset(
              "assets/icons/left_arrow.png",
              width: 10.91,
              height: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: TextField(
            textInputAction: TextInputAction.search,
            autofocus: true,
            controller: searchController,
            decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black12),
                suffixIcon: Container(
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => searchController.clear());
                    },
                  ),
                )),
            style: TextStyle(fontSize: 18),
            onSubmitted: (value) {
              if (streamController.stream != null) {
                setState(() {
                  isSwitch = false;
                });
              }
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isSearching = true;
                  isSwitch = true;
                });
                _search(value);
              }
            },
          ),
          elevation: 0.0,
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Divider(
              height: 1,
            ),
            Expanded(
                flex: 1,
                child: isSearching
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.green),
                          )
                        ],
                      )
                    : StreamBuilder<List<ProductCategory>>(
                        stream: streamController.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ProductCategory>> snapshot) {
                          return (snapshot.hasData &&
                                  !snapshot.hasError &&
                                  snapshot.data != null)
                              ? (snapshot.data.length > 0)
                                  ? Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  20, 10, 0, 0),
                                              child: Text(
                                                "${snapshot.data.length} results",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xffA8A8A8),
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return isSwitch
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0.0),
                                                        child: InkWell(
                                                          focusColor:
                                                              Colors.green,
                                                          hoverColor:
                                                              Colors.green,
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ProductDetailScreen(
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .id,
                                                                        languageConfig.getTextByKey(
                                                                            snapshot.data[index].toJson(),
                                                                            "name"))));
                                                          },
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            18.0,
                                                                        left:
                                                                            18.0),
                                                                child: Icon(
                                                                  Icons.search,
                                                                  color: Colors
                                                                      .black12,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 13,
                                                                        bottom:
                                                                            13),
                                                                child: Text(
                                                                  snapshot.data[index].name_en !=
                                                                          null
                                                                      ? snapshot
                                                                          .data[
                                                                              index]
                                                                          .name_en
                                                                      : "N/A",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10.0,
                                                            right: 0.0),
                                                        child: InkWell(
                                                          focusColor:
                                                              Colors.green,
                                                          hoverColor:
                                                              Colors.green,
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ProductDetailScreen(
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .id,
                                                                        languageConfig.getTextByKey(
                                                                            snapshot.data[index].toJson(),
                                                                            "name"))));
                                                          },
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            18.0,
                                                                        left:
                                                                            18.0),
                                                                child:
                                                                    FadeInImage(
                                                                  width: 54,
                                                                  height: 54,
                                                                  image: snapshot
                                                                              .data !=
                                                                          null
                                                                      ? NetworkImage(
                                                                          "${appConfig.baseUrl}/${snapshot.data[index].item_img}")
                                                                      : AssetImage(
                                                                          "assets/images/placeholder.png"),
                                                                  placeholder:
                                                                      AssetImage(
                                                                          "assets/images/placeholder.png"),
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(snapshot
                                                                              .data !=
                                                                          null
                                                                      ? languageConfig.getTextByKey(
                                                                          snapshot
                                                                              .data[index]
                                                                              .toJson(),
                                                                          "name")
                                                                      : "N/A"),
                                                                  Text(
                                                                    snapshot.data[index].prices.length >
                                                                            0
                                                                        ? "\$ ${snapshot.data[index].prices[0].price} / ${languageConfig.getTextByKey(snapshot.data[index].prices[0].uom.toJson(), "name")}"
                                                                        : "N/A",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ));
                                              }),
                                        )
                                      ],
                                    )
                                  : EmptyData()
                              : Text("");
                        },
                      ))
          ],
        )));
  }
}
