import 'dart:async';

import 'package:badges/badges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/product_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/model/chat_model.dart';
import 'package:flutter_kickstart/presentations/widget/chat/chat_item.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../empty_data.dart';

class LastChatProduct extends StatefulWidget {
  final int id;

  LastChatProduct({this.id});

  @override
  State<StatefulWidget> createState() {
    return _LastChatProductWidget();
  }
}

class _LastChatProductWidget extends State<LastChatProduct>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int counter = 1;
  int limit = 9;
  String lastKey = "";
  bool isSeen = false;

  StreamController _messageStream = BehaviorSubject<List<ChatResponse>>();

  ScrollController _controller;
  List<ChatResponse> chats;

  var notesReference;
  StreamSubscription<Event> _onNoteAddedSubscription;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && ! _controller.position.outOfRange) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notesReference = Provider.of<ChatProvider>(context, listen: false).dbreference;
      _listenToProductChatFirstTime();
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    LanguageConfig languageConfig = LanguageWrapper.of(context);

    return StreamBuilder<List<ChatResponse>>(
        stream: _messageStream.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ChatResponse>> snapshot) {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
            return (snapshot.data.length > 0)
                ? ListView.builder(
                    addAutomaticKeepAlives: true,
//                controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index];
                      return Row(
                        children: <Widget>[
                          Card(
                            margin: EdgeInsets.only(
                                right: 10.0, bottom: 5, top: 5, left: 1),
                            child: Container(
                                width: 125,
                                color: Colors.white,
                                margin: EdgeInsets.all(1),
                                child: data != null && data.users != null
                                    ? Material(
                                        child: Badge(
                                          badgeContent: Text(""),
                                          shape: BadgeShape.circle,
                                          // ignore: unrelated_type_equality_checks
                                          showBadge: data.users != null &&
                                                  data.lastMessage != null
                                              ? data.lastMessage.key ==
                                                      data.users["${widget.id}"]
                                                          ?.lastSeen
                                                  ? false
                                                  : true
                                              : false,
                                          child: ChatItem(
                                              fireBaseKey: data.key,
                                              chatResponse: data),
                                        ),
                                      )
                                    : Container(child: Text("no chat"))),
                          )
                        ],
                      );
                    })
                : EmptyData();
          } else {
            Provider.of<ProductProvider>(context, listen: false).setMessage(true);
            return EmptyData();
          }
//          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }

  @override
  void dispose() {
    _onNoteAddedSubscription?.cancel();
    _messageStream.close();
    super.dispose();
  }

  void _listenToProductChatFirstTime() async {
    var user = Provider.of<UserProvider>(
        context, listen: false)
        .getUser();
    _onNoteAddedSubscription = notesReference
        .orderByChild('users/${user.id}/userId')
        .equalTo(user.id)
        .onValue
        .listen((onData) {
      var chatList = (onData.snapshot.value as Map<dynamic, dynamic>)
          .map((key, value) {
            var chat = ChatResponse.fromJson(value);
            chat.key = key;
            return MapEntry(key, chat);
          })
          .values
          .toList();

      chatList.sort((ChatResponse a, ChatResponse b) {
        return b.lastTimeStamp - a.lastTimeStamp;
      });
      _messageStream.add(chatList);
    });
  }
}
