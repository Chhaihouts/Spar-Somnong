import 'dart:convert';
import 'dart:io';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/last_chat_model.dart';
import 'package:http/http.dart' as http;

var appConfig = Config.fromJson(config);

Future<LastChatResponse> getLastChat(String fireBaseKey) async {

  var response = await http.get("${appConfig.baseUrl}/api/chat/$fireBaseKey",
      headers: {HttpHeaders.contentTypeHeader: "application/json"});

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    LastChatResponse chatResponse = LastChatResponse.fromJson(json);
    return chatResponse;
  } else if (response.statusCode == 401) {
    return null;
  } else {
    throw Exception("${response.statusCode}");
  }
}

Future<LastChatResponse> createChatProduct(String token, int productId) async {
  print("token is $token");
  print("product id is $productId");

  var body = {
    "item_id": productId.toString()
  };

  var response = await http.post("${appConfig.baseUrl}/api/chat/admin",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token}"
      }, body: body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    LastChatResponse chatResponse = LastChatResponse.fromJson(json);
    return chatResponse;
  } else if (response.statusCode == 401) {
    return null;
  } else {
    throw Exception("${response.statusCode}");
  }
}

