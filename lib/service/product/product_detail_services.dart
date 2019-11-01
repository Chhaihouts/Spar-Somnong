import 'dart:convert';
import 'dart:io';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/last_chat_model.dart';
import 'package:flutter_kickstart/model/prode_detail_model.dart';
import 'package:http/http.dart' as http;

var appConfig = Config.fromJson(config);

Future<ProductDetail> getProductDetail(int id) async {
  final response = await http.get("${appConfig.baseUrl}/api/products/$id");

  var json = jsonDecode(response.body);
  ProductDetailResponse productDetailResponse =
      ProductDetailResponse.fromJson(json);
  return productDetailResponse.data;
}

Future<ProductDetail> getProductDetailClient(int id) async {
  var response = await http.get(
      Uri.encodeFull("${appConfig.baseUrl}/api/products/$id"),
      headers: {"Accept": "application/json"});

  var json = jsonDecode(response.body);
  ProductDetailResponse productDetailResponse =
      ProductDetailResponse.fromJson(json);
  return productDetailResponse.data;
}

Future<LastChatResponse> getChatProductDetail(String token, int productId) async {
  var response = await http.get("${appConfig.baseUrl}/api/chat/products/$productId", headers: {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer $token}"
  });

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
