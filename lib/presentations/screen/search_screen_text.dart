import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class SearchScreenText extends StatefulWidget {
  bool isSearching;
  List<ProductCategory> productCategory;

  SearchScreenText(this.isSearching, this.productCategory);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenTextState();
  }
}

class _SearchScreenTextState extends State<SearchScreenText> {
  StreamController streamController = BehaviorSubject<List<ProductCategory>>();

  @override
  void initState() {
    streamController.add(widget.productCategory);
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: <Widget>[
        Divider(
          height: 1,
        ),
        Expanded(
            flex: 1,
            child: widget.isSearching
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()],
                  )
                : StreamBuilder<List<ProductCategory>>(
                    stream: streamController.stream,
                    builder: (BuildContext context, AsyncSnapshot<List<ProductCategory>> snapshot) {
                      return (snapshot.hasData &&
                              !snapshot.hasError &&
                              snapshot.data != null)
                          ? (snapshot.data.length > 0)
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(
                                            left: 0.0, right: 0.0),
                                        child: InkWell(
                                          focusColor: Colors.green,
                                          hoverColor: Colors.green,
                                          onTap: () {
                                            print(
                                                "product ${snapshot.data[index].id}");
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 18.0, left: 18.0),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 13, bottom: 13),
                                                child: Text(
                                                  snapshot.data[index]
                                                              .name_en !=
                                                          null
                                                      ? snapshot
                                                          .data[index].name_en
                                                      : "N/A",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  })
                              : EmptyData()
                          : Text("");
                    },
                  ))
      ],
    )));
  }
}
