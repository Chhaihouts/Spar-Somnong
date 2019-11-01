import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/chat_provider.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/model/chat_model.dart';
import 'package:flutter_kickstart/service/upload_file_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/ios_quality.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'message_item.dart';

class ChatWidget extends StatefulWidget {
  final double height;
  final String fireBaseKey;
  const ChatWidget({Key key, this.fireBaseKey, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatWidgetState();
  }
}

class _ChatWidgetState extends State<ChatWidget> {

  String _path;
  File _image;
  String _lastMessageKey = "";
  String _firstMessageKey = "";
  String _chatKey;
  bool isRecording = false;
  bool _isRecording = false;
  bool _isPlaying = false;

  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController;
  StreamController<String> _streamController = StreamController<String>();
  StreamController _chatController = BehaviorSubject<List<Message>>();

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00:00';
  String oldKey = "";
  List<String> message = [];
  List<String> voiceList = [];
  List<Messages> messages = [];

  double _dbLevel;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  var notesReference = FirebaseDatabase.instance
      .reference()
      .child(FIRE_BASE_PARENT_DEVELOPMENT)
      .child(FIRE_BASE_CHAT);
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<String> chatkeySubscription;
  StreamController _messageStream = BehaviorSubject<List<Messages>>();
  Stream _providerStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chatkeySubscription = Provider
          .of<ChatProvider>(context, listen: false)
          .chatKeyStream
          .listen((key) {
        _chatKey = key;
        _providerFireBaseFirstTime();
      });
    });


    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _streamController.add(messageController.text);
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  void _providerFireBaseFirstTime() async {
    var chatKey = _chatKey;
    var user = Provider.of<UserProvider>(
        context, listen: false).getUser();

    if (chatKey != oldKey) {
      _onNoteAddedSubscription?.cancel();
      oldKey = chatKey;
      await _listenToChatFirstTime(context, chatKey, user.id);
      _providerRealTime(chatKey, _firstMessageKey);
    } else {
      print(" else chat key $chatKey old key $oldKey");
    }
  }

  void _providerRealTime(String chatKey, String firstMessageKey) {
    _onNoteAddedSubscription = notesReference
        .child("$chatKey/$FIRE_BASE_MESSAGES")
        .limitToLast(1)
        .onChildAdded
        .listen(_listenToRealTimeChat);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xffDEDEDE),
      constraints: BoxConstraints(
        maxHeight: widget.height ?? 0,
      ),
      child: StreamBuilder<List<Messages>>(
        stream: _messageStream.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Messages>> snapshot) {
          return
            (!snapshot.hasError
                && snapshot.hasData
                && snapshot.data != null)
                ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageItem(snapshot.data[index].message,
                            snapshot.data[index].userId);
                      }),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          icon: Image.asset("assets/icons/camera.png",
                              width: 28, height: 25),
                          onPressed: () {
                            _settingModalBottomSheet(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: isRecording
                              ? Text(this._recorderTxt)
                              : TextFormField(
                            controller: messageController,
                            textInputAction: TextInputAction.send,
                            onChanged: (value) {
                              _streamController.add(value);
                            },
                            decoration: InputDecoration.collapsed(
                                hintText: LanguageWrapper.of(context)
                                    .text("type_something"),
                                hintStyle:
                                TextStyle(color: Colors.black12),
                                focusColor: Colors.green),
                          ),
                        ),
                      ),
                      Container(
                        child: StreamBuilder(
                          stream: _streamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.data != "") {
                              return IconButton(
                                icon: Icon(Icons.send),
                                iconSize: 28,
                                onPressed: () {
                                  var user = Provider.of<UserProvider>(
                                      context, listen: false)
                                      .getUser();
                                  setState(() {
                                    _sendToRealTimeChat(
                                        oldKey,
                                        messageController.text, user.id);
                                    messageController.text = "";
                                  });
                                  _scrollController.animateTo(
                                    _scrollController
                                        .position.maxScrollExtent -
                                        1,
                                    curve: Curves.easeOut,
                                    duration:
                                    const Duration(milliseconds: 300),
                                  );
                                },
                              );
                            }
                            return isRecording
                                ? Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                  ),
                                  iconSize: 28,
                                  onPressed: () {
                                    setState(() {
                                      isRecording = false;
                                    });
                                    this.stopRecorder();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.send,
                                  ),
                                  iconSize: 28,
                                  onPressed: () {
                                    setState(() {
                                      isRecording = false;
                                      voiceList.add(this._path);
                                    });
                                    this.stopRecorder();
                                  },
                                )
                              ],
                            )
                                : IconButton(
                              icon: Icon(
                                Icons.keyboard_voice,
                              ),
                              iconSize: 28,
                              onPressed: () {
                                setState(() {
                                  isRecording = true;
                                });
                                this.startRecorder();
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
                : Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    _streamController.close();
    _scrollController.dispose();
    if (flutterSound?.isRecording) {
      flutterSound?.stopRecorder();
    }
    _chatController.close();
    _messageStream.close();
    _onNoteAddedSubscription?.cancel();
    chatkeySubscription?.cancel();
    super.dispose();
  }


  Future<void> _listenToChatFirstTime(BuildContext context, String chatKey,
      int userId) async {
    List<Messages> chat;
    print("chat _listenToChatFirstTime");
    DataSnapshot response = await notesReference
        .child("$chatKey/$FIRE_BASE_MESSAGES")
        .limitToLast(11)
        .once();
    if (response.value != null) {
      print("chat _listenToChatFirstTime not null");

      chat =
          (response.value as LinkedHashMap<dynamic, dynamic>).map((key, value) {
            var messages = Messages.fromJson(value);
            messages.key = key;
            return MapEntry(key, messages);
          }).values.toList();
      chat.sort((Messages a, Messages b) => a.key.compareTo(b.key));
      chat.removeLast();
      _lastMessageKey = chat.length > 0 ? chat[0].key : "";
      _firstMessageKey = chat.length > 0 ? chat.last.key : "";

      messages.clear();
      messages.addAll(chat);
      _messageStream.add(messages);

      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });

    } else {
      messages.length = 0;
      _messageStream.add(messages);
    }
  }

  _listenToPreviousChat({String chatKey, String messageKey}) async {

    List<Messages> chat;
    var response = await notesReference
        .child("$chatKey/$FIRE_BASE_MESSAGES")
        .orderByKey()
        .endAt(_lastMessageKey)
        .limitToLast(4)
        .once();

    chat = (response.value as Map<dynamic, dynamic>).map((key, value) {
      var messages = Messages.fromJson(value);
      messages.key = key;
      return MapEntry(key, messages);
    }).values.toList();
    chat.sort((Messages a, Messages b) => a.key.compareTo(b.key));
    chat.removeLast();
    _lastMessageKey = chat[0].key;
    messages.insertAll(0, chat);
    _messageStream.add(messages);
  }

  _listenToRealTimeChat(Event event) async {
    var message = Messages.fromJson(event.snapshot.value);
    var user  = Provider.of<UserProvider>(context, listen: false).getUser();
    message.key = event.snapshot.key;
    MapEntry(event.snapshot.key, message);
    messages.add(message);
    _messageStream.add(messages);

    notesReference
        .child("$_chatKey/users/${user.id}")
        .update({
      "lastSeen": "${event.snapshot.key}"
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });

  }

  _sendToRealTimeChat(String chatKey, String text, int userId) {
    Messages message = Messages("", Message(text, DateTime
        .now()
        .millisecondsSinceEpoch, 1), userId);
    String newKey = notesReference
        .child('$chatKey/$FIRE_BASE_MESSAGES')
        .push()
        .key;
    var create = notesReference.child("$chatKey/$FIRE_BASE_MESSAGES")
        .child(newKey)
        .set({
      "message": {
        "data": text,
        "lastTimeStamp": message.message.lastTimeStamp,
        "type": message.message.type
      },
      "userId": userId
    });

    if (create != null) {
      notesReference.child("$chatKey/$FIRE_BASE_LAST_MESSAGE").update({
        "data": text,
        "key": newKey,
        "type": message.message.type
      });
      notesReference.child("$chatKey").update({
        "lastTimeStamp": message.message.lastTimeStamp
      });
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Take photo'),
                    onTap: () =>
                    {
                      openCamera(context),
                      Navigator.of(context).pop()
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Choose from gallery'),
                  onTap: () =>
                  {
                    openGallery(),
                    Navigator.of(context).pop()
                  },
                ),
              ],
            ),
          );
        });
  }

  //Open gallery
  Future openGallery() async {
    var user = Provider.of<UserProvider>(
        context, listen: false)
        .getUser();
    var chatKey = _chatKey;

    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 300,
        imageQuality: 100);

    if (image != null) {
      FormData formData;
      _image = File(image.path);
      formData = FormData.fromMap({
        "type": "PHOTO",
        "file": MultipartFile.fromBytes(_image.readAsBytesSync(),
            filename: 'file.jpg',
            contentType: MediaType('image', 'jpg'))
      });
      var response = await uploadFileService(formData);
      if (response.message == "success") {
        Messages message = Messages("", Message(_image.path, DateTime
            .now()
            .millisecondsSinceEpoch, 2), user.id);
        String newKey = notesReference
            .child('$chatKey/$FIRE_BASE_MESSAGES')
            .push()
            .key;
        var create = notesReference.child("$chatKey/$FIRE_BASE_MESSAGES")
            .child(newKey)
            .set({
          "message": {
            "data": response.data.file,
            "lastTimeStamp": message.message.lastTimeStamp,
            "type": message.message.type
          },
          "userId": user.id
        });

        if (create != null) {
          notesReference.child("$chatKey/$FIRE_BASE_LAST_MESSAGE").update({
            "data": response.data.file,
            "key": newKey,
            "type": message.message.type
          });
          notesReference.child("$chatKey").update({
            "lastTimeStamp": message.message.lastTimeStamp
          });
        }
      }
    }
  }
  // Open Camera
  Future openCamera(BuildContext context) async {
    var user = Provider.of<UserProvider>(
        context, listen: false)
        .getUser();
    var chatKey = _chatKey;

    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 100);

    if (image != null) {
      FormData formData;
      _image = File(image.path);
      if (Platform.isAndroid) {
        _image = await FlutterExifRotation.rotateImage(path: image.path);
      }
      formData = FormData.fromMap({
        "type": "PHOTO",
        "file": MultipartFile.fromBytes(_image.readAsBytesSync(),
            filename: 'file.jpg',
            contentType: MediaType('image', 'jpg'))
      });
      var response = await uploadFileService(formData);
      if (response.message == "success") {
        Messages message = Messages("", Message(_image.path, DateTime
            .now()
            .millisecondsSinceEpoch, 2), user.id);
        String newKey = notesReference
            .child('$chatKey/$FIRE_BASE_MESSAGES')
            .push()
            .key;
        var create = notesReference.child("$chatKey/$FIRE_BASE_MESSAGES")
            .child(newKey)
            .set({
          "message": {
            "data": response.data.file,
            "lastTimeStamp": message.message.lastTimeStamp,
            "type": message.message.type
          },
          "userId": user.id
        });

        if (create != null) {
          notesReference.child("$chatKey/$FIRE_BASE_LAST_MESSAGE").update({
            "data": response.data.file,
            "key": newKey,
            "type": message.message.type
          });
          notesReference.child("$chatKey").update({
            "lastTimeStamp": message.message.lastTimeStamp
          });
        }
      }
    }
  }

  void startRecorder() async {
    try {
      String path = await flutterSound.startRecorder(
        null,
        bitRate: 128000,
        iosQuality: IosQuality.HIGH,
      );
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
            setState(() {
              this._dbLevel = value;
            });
          });
      this.setState(() {
        this._isRecording = true;
        this._path = path;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {
    var user = Provider.of<UserProvider>(
        context, listen: false)
        .getUser();
    var chatKey = _chatKey;

    try {
      await flutterSound.stopRecorder();

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
      if (_path != null) {
        FormData formData;
        formData = FormData.fromMap({
          "type": "SOUND",
          "file": await MultipartFile.fromFile(_path)
        });

        var response = await uploadFileService(formData);

        if (response.message == "success") {
          Messages message = Messages("", Message(_path, DateTime
              .now()
              .millisecondsSinceEpoch, 3), user.id);
          String newKey = notesReference
              .child('$chatKey/$FIRE_BASE_MESSAGES')
              .push()
              .key;
          var create = notesReference.child("$chatKey/$FIRE_BASE_MESSAGES")
              .child(newKey)
              .set({
            "message": {
              "data": response.data.file,
              "lastTimeStamp": message.message.lastTimeStamp,
              "type": message.message.type
            },
            "userId": user.id
          });

          if (create != null) {
            notesReference.child("$chatKey/$FIRE_BASE_LAST_MESSAGE").update({
              "data": response.data.file,
              "key": newKey,
              "type": message.message.type
            });
            notesReference.child("$chatKey").update({
              "lastTimeStamp": message.message.lastTimeStamp
            });
          }
        }
      }

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        var chatKey = _chatKey;
        _listenToPreviousChat(chatKey: chatKey);
      }
    }
  }

}