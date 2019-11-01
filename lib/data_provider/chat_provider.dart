import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/model/chat_model.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatProvider with ChangeNotifier {
  String _fireBaseKey;
  String _messageKey;
  String _firstMessageKey;
  String _lastMessageKey;
  LastMessage _lastMessage;
  ProductCategory productCategory;
  var chatKeyStream;
  var chatChangeStream;
  int _numberOfChat=0;
  bool _hasSeenAll = true;
  DatabaseReference dbreference;


  ChatProvider(){
    chatKeyStream = BehaviorSubject<String>();
    chatChangeStream = BehaviorSubject<int>();
    dbreference = FirebaseDatabase.instance
        .reference()
        .child(FIRE_BASE_PARENT_DEVELOPMENT)
        .child(FIRE_BASE_CHAT);
  }

  String get fireBaseKey => _fireBaseKey;

  set fireBaseKey(String value) {
    _fireBaseKey = value;
    notifyListeners();
  }

  void setKey(String key, {LastMessage lastMessage}) {
    _fireBaseKey = key;
    _lastMessage = lastMessage;
    notifyListeners();
  }

  String getKey() {
    return _fireBaseKey;
  }

  LastMessage getLastMessage() {
    return _lastMessage;
  }

  void setMessageKey(String key) {
    _messageKey = key;
    notifyListeners();
  }

  String getMessageKey() {
    return _messageKey;
  }

  void setFirstMessageKey(String key) {
    this._firstMessageKey = key;
    notifyListeners();
  }

  String getFirstMessageKey() {
    return _firstMessageKey;
  }

  void setLastMessageKey(String key) {
    this._lastMessageKey = key;
    notifyListeners();
  }

  String getLastMessageKey() {
    return _lastMessageKey;
  }

  void clearKey() {
    _fireBaseKey = null;
    notifyListeners();
  }

  void clearMessageKey() {
    _messageKey = null;
    notifyListeners();
  }

  void clearFirstMessage() {
    _firstMessageKey = null;
    notifyListeners();
  }

  void clearLastMessage() {
    _lastMessageKey = null;
    notifyListeners();
  }

  void setProductCategory(ProductCategory productCategory) {
    this.productCategory = productCategory;
    notifyListeners();
  }

  get numberOfChat=>_numberOfChat;
  set numberOfChat(int val){
    _numberOfChat = val;
    notifyListeners();
  }

  get hasSeenAll=>_hasSeenAll;
  set hasSeenAll(bool val){
    _hasSeenAll = val;
    notifyListeners();
  }

  ProductCategory getProductCategory () => productCategory;
}
