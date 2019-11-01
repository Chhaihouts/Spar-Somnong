import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/product_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/chat/chat_widget.dart';
import 'package:flutter_kickstart/presentations/widget/chat/last_chat_product_widget.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final int id;
  final String name;

  const MessageScreen({Key key, this.id, this.name});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var appConfig = Config.fromJson(config);
  var noData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).getUser();
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      appBar: AppBarWidget.buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-80,
          child: Selector<ChatProvider,bool>(
            selector: (_,ChatProvider chatProvider)=>chatProvider.numberOfChat>0,
            builder: (_,bool hasChat,__){
              return hasChat ? Consumer<ChatProvider>(
                builder: (_,data,__){
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Consumer<ProductProvider>(builder: (context, data, _){
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 8, top: 15),
                                        child: FadeInImage(
                                          width: 86,
                                          height: 86,
                                          image: (data != null &&
                                              data.productCategory != null) ?
                                          NetworkImage("${appConfig.baseUrl}/${data.productCategory.item_img}")
                                              : AssetImage(
                                              "assets/images/placeholder.png"),
                                          placeholder: AssetImage(
                                              "assets/images/placeholder.png"),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Text(
                                    data != null && data.productCategory != null
                                        ? languageConfig
                                        .getTextByKey(
                                        data.productCategory.toJson(), "name")
                                        : "N/A",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          );
                        })
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 15, left: 15, right: 15, top: 0),
                          child: Card(
                              elevation: 2,
                              child: ChatWidget(height: 200)
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        margin: EdgeInsets.only(
                            bottom: 5, left: 15, right: 15, top: 0),
                        child: LastChatProduct(id: user != null ? user.id : 96),
                      )
                    ],
                  );
                },
              ) : EmptyData();
            },
          )
        )
      ),
    );
  }

  itemProduct() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Consumer<UserProvider>(builder: (context, data, _) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8, top: 15),
                      child: FadeInImage(
                        width: 86,
                        height: 86,
                        image: AssetImage("assets/images/cemen.png"),
                        placeholder: AssetImage(
                            "assets/images/placeholder.png"),
                      ),
                    );
                  })
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Text("Product name",
                style: TextStyle(
                  fontSize: 12,
                )),
          ),
          Text("\$100 / Ton",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
