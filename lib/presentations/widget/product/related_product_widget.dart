import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/screen/product_detail_screen.dart';
import 'package:flutter_kickstart/presentations/widget/product_item.dart';
import 'package:flutter_kickstart/service/product/related_product_service.dart';
import 'package:rxdart/rxdart.dart';

import '../empty_data.dart';

class RelatedProductListWidget extends StatefulWidget {
  final int id;

  RelatedProductListWidget(this.id);

  @override
  State<StatefulWidget> createState() {
    return _RelatedProductListWidget();
  }
}

class _RelatedProductListWidget extends State<RelatedProductListWidget>
    with AutomaticKeepAliveClientMixin {
  var appConfig = Config.fromJson(config);
  int page = 1;
  int limit = 3;
  var _visible = true;
  List<ProductCategory> productCategories;
  ScrollController _controller;
  StreamController _streamController = BehaviorSubject<List<ProductCategory>>();

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page++;
      });
      getProductRelatedClient(widget.id, page, limit).then((onValue) {
        _streamController.add(onValue);
        setState(() {
          productCategories.addAll(onValue);
        });
        if (onValue.length == 0 ){
          setState(() {
            _visible = false;
          });
        }
        print("${onValue.length} Welloday");
      }).catchError((onError) {
        print("error product category ${onError.toString()}");
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getProductRelatedClient(widget.id, page, limit).then((onValue) {
      _streamController.add(onValue);
      setState(() {
        productCategories = onValue;
      });
    }).catchError((onError) {
      print("error product category ${onError.toString()}");
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return Builder(builder: (BuildContext context) {
      return StreamBuilder<List<ProductCategory>>(
          stream: Stream.value(productCategories),
          builder: (BuildContext context,
              AsyncSnapshot<List<ProductCategory>> snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data != null) {
              return (snapshot.data.length > 0)
                  ? Container(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.only(right: 5.0, bottom: 5, top: 5, left: 1),
                                child: Container(
                                  width: 125,
//                                color: Colors.white,
                                  margin: EdgeInsets.all(5),
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return InkWell(
                                        highlightColor: Theme.of(context).highlightColor,
                                        child: ProductItem(productCategory: productCategories[index]),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ProductDetailScreen(
                                                      productCategories[index].id,
                                                      productCategories[index].name_en)
                                              )
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _visible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 100),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blueGrey,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : EmptyData();
            }
            return Center(child: CircularProgressIndicator());
          });
    });
  }
}
