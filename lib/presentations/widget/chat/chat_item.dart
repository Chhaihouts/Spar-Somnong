import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/product_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/chat_model.dart';
import 'package:flutter_kickstart/model/firebase_key_model.dart';
import 'package:flutter_kickstart/model/last_chat_model.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/presentations/widget/product_item.dart';
import 'package:flutter_kickstart/service/chat/chat_service.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatefulWidget {

  final String fireBaseKey;
  final ChatResponse chatResponse;

  ChatItem({this.fireBaseKey, this.chatResponse});

  @override
  State<StatefulWidget> createState() {
    return _ChatItemState();
  }
}

class _ChatItemState extends State<ChatItem> with AutomaticKeepAliveClientMixin {

  var appConfig = Config.fromJson(config);

  LastChatResponse chatResponse;
  ProductCategory productCategory = ProductCategory(
      0,
      "",
      "",
      "",
      "",
      "",
      List()
  );


  final notesReference = FirebaseDatabase.instance
      .reference()
      .child(FIRE_BASE_PARENT_DEVELOPMENT)
      .child(FIRE_BASE_CHAT);

  Future<ProductCategory> _futureCategory() async {
    var data = await getLastChat(widget.fireBaseKey);
    try {
      if (data.data.product == null) {
        return ProductCategory(
            0,
            "",
            "",
            "",
            "",
            "",
            List(0)
        );
      }
      productCategory.item_img = data.data.product.item_img ?? "";
      productCategory.name_en = data.data.product.name_en ?? "";
      productCategory.name_ch = data.data.product.name_ch ?? "";
      productCategory.name_kh = data.data.product.name_kh ?? "";
      productCategory.prices = data.data.product.prices ?? "";
      setState(() {
        productCategory = productCategory;
      });
    } catch (err) {
      print("product $err");
    }
    return productCategory;
  }

  _onTimeOut() {

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: () {
//        Provider.of<ChatProvider>(
//            context, listen: false).setKey(
//            widget.chatResponse.key,
//            lastMessage: widget.chatResponse.lastMessage);
//
        Provider.of<ChatProvider>(context, listen: false).chatKeyStream.add(widget.chatResponse.key);
        Provider.of<ProductProvider>(context).setProductCategory(productCategory);
//        var chatKey = Provider.of<ChatProvider>(
//            context, listen: true)
//            .getKey();

        var user = Provider.of<UserProvider>(
            context, listen: true)
            .getUser();
        if ((widget.chatResponse.key != null || widget.chatResponse.key != "")) {
          notesReference
              .child("${widget.chatResponse.key}/users/${user.id}")
              .update({
            "lastSeen": "${widget.chatResponse
                .lastMessage.key}"
          });
        }
      },
      child: FutureBuilder(
          future: _futureCategory(),
          builder: (BuildContext context,
              AsyncSnapshot<ProductCategory> snapshot) {
            if (snapshot.data != null && snapshot.hasData &&
                !snapshot.hasError) {
              var productCategory = snapshot.data;
              return Container(
                child: ProductItem(productCategory: productCategory),
              );
            }
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}