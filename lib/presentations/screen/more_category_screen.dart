import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/category_model.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/screen/product_detail_screen.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:flutter_kickstart/presentations/widget/product_item.dart';
import 'package:flutter_kickstart/service/product/product_category_services.dart';

class MoreCategoryScreen extends StatefulWidget {
  final Category category;

  MoreCategoryScreen(this.category);

  @override
  State<StatefulWidget> createState() {
    return _MoreCategoryScreen();
  }
}

class _MoreCategoryScreen extends State<MoreCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int limit = 9;
  List<ProductCategory> productCategories;
  ScrollController _controller;

  var appConfig = Config.fromJson(config);

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page++;
      });
      productCategoriesClient(widget.category.id, page, limit).then((onValue) {
        productCategories.addAll(onValue);
        setState(() {
          productCategories = productCategories;
        });
      }).catchError((onError) {
        print("error product category ${onError.toString()}");
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int x = MediaQuery.of(context).size.width ~/ 125;
      int y = MediaQuery.of(context).size.height ~/
          ((MediaQuery.of(context).size.width / x) * 4 / 3);
      limit = x * y;
      print("number per screen $limit");
      productCategoriesClient(widget.category.id, page, limit).then((onValue) {
        setState(() {
          productCategories = onValue;
        });
      }).catchError((onError) {
        print("error product category ${onError.toString()}");
      }).timeout(Duration(seconds: 10));
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return Scaffold(
      appBar: AppBarWidget.buildAppBar(context),
      body: Builder(builder: (BuildContext context) {
        return StreamBuilder<List<ProductCategory>>(
            stream: Stream.value(productCategories),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductCategory>> snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data != null) {
                return (snapshot.data.length > 0)
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(top: 4, bottom: 4, left: 4),
                              child: Text("${snapshot.data.length} results",
                                  textAlign: TextAlign.left),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: GridView.builder(
                                    controller: _controller,
                                    itemCount: productCategories.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
//                                            crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
                                            crossAxisCount: 3,
                                            childAspectRatio: 3 / 4.5),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.all(1),
                                          child: Card(
                                              margin: EdgeInsets.only(right: 5.0, bottom: 5, top: 5, left: 1),
                                              elevation: 2,
                                              child: InkWell(
                                                child: Container(
//                                                width: 125,
//                                                margin: EdgeInsets.all(5),
                                                  child: Builder(
                                                    builder: (
                                                        BuildContext context) {
                                                      return ProductItem(
                                                        productCategory: productCategories[index],);
                                                    },
                                                  ),
                                                ),
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
                                              )
                                          )
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      )
                    : EmptyData();
              }
              return Center(child: CircularProgressIndicator());
            });
      }),
    );
  }
}
