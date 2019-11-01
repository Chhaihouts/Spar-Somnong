import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/screen/product_detail_screen.dart';
import 'package:flutter_kickstart/presentations/widget/product_item.dart';
import 'package:flutter_kickstart/service/product/product_category_services.dart';

import '../empty_data.dart';

class ProductListWidget extends StatefulWidget {
  final int id;

  ProductListWidget(this.id);

  @override
  State<StatefulWidget> createState() {
    return _ProductListWidget();
  }
}

class _ProductListWidget extends State<ProductListWidget>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  bool _visible = false;

  List<ProductCategory> productCategories;
  ScrollController _controller;
  StreamController _streamController = StreamController();

  var appConfig = Config.fromJson(config);

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    productCategoriesClient(widget.id, page, 9).then((onValue) {
      _streamController.add(onValue);
      setState(() {
        productCategories = onValue;
        _visible = true;
      });
    }).catchError((onError) {
      print("error product category ${onError.toString()}");
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                        itemCount: productCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.only(
                                    right: 5.0, bottom: 5, top: 5, left: 1),
                                child: Container(
                                  padding: EdgeInsets.all(0.0),
                                  width: 125,
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return InkWell(
                                        child: ProductItem(
                                          productCategory: productCategories[index],),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                          productCategories[index]
                                                              .id,
                                                          productCategories[index]
                                                              .name_en)));
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
                          Container(
                              decoration: new BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(Icons.arrow_forward_ios),
                              )
                          ),
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

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page++;
      });
      productCategoriesClient(widget.id, page, 9).then((onValue) {
        print("$onValue hello world");
        if (onValue.length > 0) {
          setState(() {
            productCategories.addAll(onValue);
          });
        }else {
          setState(() {
            _visible = false;
          });
        }
      }).catchError((onError) {
        print("error product category ${onError.toString()}");
      });
    }
  }
}
