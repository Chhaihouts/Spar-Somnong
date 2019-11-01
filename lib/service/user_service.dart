import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/currency_model.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:http/http.dart' as http;

var appConfig = Config.fromJson(config);

Future<UserModel> getUser(String token) async {
  try {
    var response = await http.get("${appConfig.baseUrl}/api/auth/me", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token}"
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      UserResponse userResponse = UserResponse.fromJson(json);
      return userResponse.data;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception("${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error code $error");
  }
}

Future<Map<String, CurrencyModel>> getCurrency() async {
    var response = await http.get(
        "${appConfig.baseUrl}/api/currency/", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      Map<String, CurrencyModel> currency = (json['data'] as Map<String,
          dynamic>).map((key, value) {
        return MapEntry(key, CurrencyModel.fromJson(value[0]));
      });
      currency.addAll({
        'dollar' :CurrencyModel(
          key: 'dollar',
          amount: 1,
          id: 0,
          name: 'dollar'
        )
      });
      return currency;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception("${response.statusCode}");
    }

}
