import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/product_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/prode_detail_model.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/chat/chat_widget.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:flutter_kickstart/presentations/widget/product/order_widget.dart';
import 'package:flutter_kickstart/presentations/widget/product/related_product_widget.dart';
import 'package:flutter_kickstart/service/chat/chat_service.dart';
import 'package:flutter_kickstart/service/product/favourite_service.dart';
import 'package:flutter_kickstart/service/product/product_detail_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailScreen extends StatefulWidget {

  final int id;
  final String name;

  ProductDetailScreen(this.id, this.name);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetailScreen> {

  var appConfig = Config.fromJson(config);

  int quantity = 1;
  bool isChatted = false;
  bool isError = false;
  bool favourite = false;
  String key;
  bool showLoading = false;


  StreamController _streamController = BehaviorSubject<ProductDetail>();
  TextEditingController _controller = TextEditingController();
  ProductDetail productDetail;
  Flushbar flushBar;

  @override
  void initState() {
    super.initState();
    isFavourite(widget.id).then((data) {
      if (data.success == true) {
        setState(() {
          favourite = true;
        });
      }
    }).catchError((error) {
      print("Errror getting favourite ${error.toString()}");
    });

    getProductDetailClient(widget.id).then((data) {
      setState(() {
        productDetail = data;
      });
    }).catchError((error) {
      print("favourite erorr is ${error.toString()}");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = Provider.of<UserProvider>(context, listen: false).getUser();
      _controller.text = user.token;
      var chatProductDetail = await getChatProductDetail(user.token, widget.id);
      if (chatProductDetail != null && chatProductDetail.data != null) {
        setState(() {
          isChatted = true;
        });
        Provider.of<ChatProvider>(context, listen: false).chatKeyStream.add(chatProductDetail.data.chat_key);
      }else{
        Provider.of<ChatProvider>(context, listen: false).chatKeyStream.add(null);
      }
    });
  }

  _increaseQuantity() {
    setState(() {
      quantity++;
    });
    print("increaase");
  }

  _decreaseQuantity() {
    if (quantity != 1) {
      setState(() {
        quantity--;
      });
    }

    print("decrease");
  }

  DateTime selectedDate = DateTime.now();
  var formatter = DateFormat('dd-MMM-yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool isLogged(BuildContext context) {
    var user = Provider
        .of<UserProvider>(context, listen: false)
        .user;
    if (user != null)
      return true;
    else
      return false;
  }

  _showSnackBar(String message) {
    flushBar = Flushbar(
      backgroundColor: Color(0xff002D45),
      message: message,
      duration: Duration(seconds: 3),
    );
    flushBar.show(context);
  }

  _onTimeOut() {
    _showSnackBar("Getting data so long");
  }

  _createChat(int productId, BuildContext context) async {
    setState(() {
      showLoading = true;
    });
    var user = Provider
        .of<UserProvider>(context, listen: false)
        .user;
    if (user == null) {
      setState(() {
        showLoading = false;
      });
      Navigator.of(context).pushNamed("/login");
      return;
    } else {
      var createChatResponse = await createChatProduct(user.token, productId);
      if (createChatResponse != null) {
        setState(() {
          showLoading = false;
        });
        Provider.of<ProductProvider>(context, listen: false).setMessage(false);
        setState(() {
          isChatted = true;
        });
        Provider.of<ChatProvider>(context, listen: false).chatKeyStream.add(createChatResponse.data.chat_key);
      }
    }
  }
  _createFavourite(String token, LanguageConfig languageConfig) async{
    var favourite = await addFavourite(widget.id);
    print("favourite ${favourite.toString()}");
    if (favourite.message == SUCCESS) {
      _showSnackBar(languageConfig.text("this_product_has_already_added"));
    } else {
      _showSnackBar(languageConfig.text("this_product_have_added_to_favourite_list"));
    }
  }


  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return  Scaffold(
        appBar: AppBarWidget.buildAppBar(context),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: StreamBuilder<ProductDetail>(
            stream: Stream.value(productDetail),
            builder: (BuildContext context,
                AsyncSnapshot<ProductDetail> snapshot) {

              return (snapshot.data != null &&
                  !snapshot.hasError &&
                  snapshot.hasData)
                  ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
//                        TextFormField(
//                          controller: _controller,
//                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 129,
//                                height: 158,
                                margin: EdgeInsets.only(right: 12.0),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  child: FadeInImage(
//                                    width: 86,

                                    image: (snapshot.data.item_img !=
                                        null &&
                                        snapshot.data.item_img != "")
                                        ? NetworkImage(

                                        "${appConfig.baseUrl}/${snapshot.data.item_img}")
                                        : AssetImage(
                                        "assets/images/placeholder.png"),
                                    placeholder: AssetImage(
                                        "assets/images/placeholder.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 9),
                                        child: Text(languageConfig.getTextByKey(
                                            snapshot.data.toJson(),
                                            "name"),
                                            style: TextStyle(fontSize: 20.0)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 6),
                                        child: Text(
                                            "${languageConfig.text("description")} : ",
                                            style: TextStyle(fontSize: 15.0)),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            "${languageConfig.getTextByKey(snapshot.data.toJson(), "description")}",
                                            style: TextStyle(fontSize: 15.0),
                                            textWidthBasis: TextWidthBasis.parent,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 6),
                                        child: Text(
                                            "${languageConfig.text("specification")} : ",
                                            style: TextStyle(fontSize: 15.0)),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),
                                          child: Text(
                                              languageConfig.getTextByKey(
                                                  snapshot.data.toJson(),
                                                  "specification"),
                                              style: TextStyle(fontSize: 15.0),
                                            textWidthBasis: TextWidthBasis.parent,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 9),
                                        child: Text(
                                            "\$ ${(snapshot.data.prices.length != 0 && snapshot.data.prices != null) ? "${snapshot.data.prices[0].price} / ${snapshot.data.prices[0].uom.name_en}" : "N/A"}",
                                            style: TextStyle(fontSize: 15.0, color: Colors.red, fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                                height: 25.0,
                                                width: 28.0,
                                                child: new IconButton(
                                                    padding:
                                                    new EdgeInsets.all(
                                                        0.0),
                                                    icon:
                                                    Icon(Icons.favorite),
                                                    onPressed: () {
                                                      var user = Provider.of<UserProvider>(context, listen: false).getUser();
                                                      isLogged(context)

                                                          ? _createFavourite(user.token, languageConfig)
                                                          : Navigator
                                                          .pushNamed(
                                                          context,
                                                          "/login");
                                                    })),
                                            SizedBox(
                                                height: 25.0,
                                                width: 28.0,
                                                child: new IconButton(
                                                    padding:
                                                    new EdgeInsets.all(
                                                        0.0),
                                                    icon: Image.asset(
                                                      "assets/icons/facebook.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    onPressed: () {
                                                      isLogged(context)
                                                          ? shareToFacebook()
                                                          : Navigator
                                                          .pushNamed(
                                                          context,
                                                          "/login");
                                                    })),
                                            SizedBox(
                                                height: 25.0,
                                                width: 28.0,
                                                child: new IconButton(
                                                    padding:
                                                    new EdgeInsets.all(
                                                        0.0),
                                                    icon: Icon(Icons.share),
                                                    onPressed: () {
                                                      isLogged(context)
                                                          ? print("order")
                                                          : Navigator
                                                          .pushNamed(
                                                          context,
                                                          "/login");
                                                    })),
                                            SizedBox(
                                                height: 25.0,
                                                width: 28.0,
                                                child: new IconButton(
                                                    padding:
                                                    new EdgeInsets.all(
                                                        0.0),
                                                    icon: Image.asset(
                                                      "assets/icons/view.png",
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    onPressed: () {
                                                      isLogged(context)
                                                          ? print("order")
                                                          : Navigator
                                                          .pushNamed(
                                                          context,
                                                          "/login");
                                                    })),
                                            SizedBox(
                                                height: 15.0,
                                                width: 28.0,
                                                child: Text(
                                                  productDetail.view_cnt
                                                      .toString(),
                                                  style:
                                                  TextStyle(fontSize: 12),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                EdgeInsets.only(left: 15.0, top: 10),
                                child: Text(
                                  languageConfig.text("price_list"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                                color: Colors.black,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: <Widget>[
                                      Table(
                                        defaultColumnWidth:
                                        FlexColumnWidth(1),
                                        columnWidths: {
                                          2: FlexColumnWidth(1.5),
                                          3: FlexColumnWidth(1.5)
                                        },
                                        border: TableBorder.all(
                                            color: Colors.grey),
                                        children: [
                                          TableRow(children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                languageConfig.text("items"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                languageConfig
                                                    .text("variation"),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                languageConfig
                                                    .text("price"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                languageConfig
                                                    .text("order"),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                      Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount:
                                            snapshot.data.prices.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Table(
                                                defaultColumnWidth:
                                                FlexColumnWidth(1),
                                                columnWidths: {
                                                  2: FlexColumnWidth(1.5),
                                                  3: FlexColumnWidth(1.5)
                                                },
                                                border: TableBorder.all(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                children: [
                                                  TableRow(children: [
                                                    Container(
                                                      height: 35,
                                                      width:
                                                      double.infinity,
                                                      alignment:
                                                      Alignment.center,
                                                      margin:
                                                      EdgeInsets.all(
                                                          5.0),
                                                      child: Text(
                                                          widget.name !=
                                                              null
                                                              ? widget.name
                                                              : "N/A",
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 12)
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      alignment: Alignment.center,
                                                      margin:
                                                      EdgeInsets.all(
                                                          5.0),
                                                      child: Text(
                                                          snapshot.data
                                                              .prices !=
                                                              null
                                                              ? snapshot
                                                              .data
                                                              .prices[
                                                          index]
                                                              .variation
                                                              : "N/A",
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontSize:
                                                              12)),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      alignment:
                                                      Alignment.center,
                                                      margin:
                                                      EdgeInsets.all(
                                                          5.0),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                                "\$ ${(snapshot.data.prices != null) ? "${snapshot.data.prices[index].price} / ${languageConfig.getTextByKey(snapshot.data.prices[index].uom.toJson(), "name")}" : "N/A"}",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    decoration: (snapshot.data.prices != null && snapshot.data.prices[index].discount_dollar != null && snapshot.data.prices.length > 0 && snapshot.data.prices[index].discount_dollar > 0) ? TextDecoration.lineThrough : null
                                                                )
                                                            ),
                                                            (snapshot.data.prices != null && snapshot.data.prices[index].discount_dollar != null && snapshot.data.prices.length > 0 && snapshot.data.prices[index].discount_dollar > 0) ? Text(
                                                                "\$ ${(snapshot.data.prices != null) ? "${snapshot.data.prices[index].discount_dollar} / ${languageConfig.getTextByKey(snapshot.data.prices[index].uom.toJson(), "name")}" : "N/A"}",
                                                                style: TextStyle(
                                                                  color: Theme.of(context).primaryColor,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold
                                                                )
                                                            ) : SizedBox.shrink(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      margin:
                                                      EdgeInsets.all(4),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          OrderWidget(
                                                              increaseOnPress:
                                                                  () =>
                                                                  _increaseQuantity(),
                                                              decreaseOnPress:
                                                                  () =>
                                                                  _decreaseQuantity(),
                                                              quantity:
                                                              quantity)
                                                        ],
                                                      ),
                                                    )
                                                  ])
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Theme.of(context).accentColor,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 18),
                                      child: Text(
                                        "Data arrive on site",
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "${formatter.format(selectedDate.toLocal())}",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                _selectDate(context),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  margin:
                                  EdgeInsets.only(top: 15, bottom: 0),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 188,
                                    height: 40,
                                    child: FlatButton(
                                      textColor: Colors.white,
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                          languageConfig.text("order")),
                                      onPressed: () {
                                        isLogged(context)
                                            ? Provider.of<ChatProvider>(
                                            context, listen: false)
                                            .setKey(key)
                                            : Navigator.pushNamed(
                                            context, "/login");
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 15, left: 15, right: 15, top: 0),
                          child: Card(
                            elevation: 2,
//                            child: ChatWidget(height: 400),
                              child: isChatted
                                  ? ChatWidget(height: 400) : Container(
                                width: double.infinity,
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          _createChat(widget.id, context);
                                        },
                                        child: Text("Create chat"),
                                      ),
                                      (showLoading) ? Visibility(
                                        visible: showLoading,
                                        child: SpinKitThreeBounce(
                                          color: Colors.black,
                                          size: 15.0,
                                        ),
                                      ) : SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(
                                    languageConfig
                                        .text("contact_information"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.mobile.length,
                                    itemBuilder:
                                        (BuildContext context, int i) {
                                      return (snapshot.data.mobile.length >
                                          0 &&
                                          snapshot.data.mobile != null)
                                          ? Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Text(
                                                  "${snapshot.data.mobile[i].company.name}",
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: TextStyle(
                                                      height: 1.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  ": ${snapshot.data.mobile[i].phone}",
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: TextStyle(
                                                      height: 1.5),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(
                                        width: double.infinity,
                                        height: 80,
                                        child: EmptyData(),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(
                                  languageConfig.text("related_product"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Container(
                                height: 200,
                                margin: EdgeInsets.only(bottom: 15),
                                child: RelatedProductListWidget(widget.id),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                  : Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }

  shareToFacebook() {
    print("object");
  }

}
