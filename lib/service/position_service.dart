import 'dart:convert';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/position_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var appConfig = Config.fromJson(config);

Future<List<Position>> getPosition() async {
  final response = await http.get("${appConfig.baseUrl}/api/positions");

  var json = jsonDecode(response.body);
  PositionResponse positionResponse = PositionResponse.fromJson(json);
  return positionResponse.data;
}

Future<List<Position>> positionClient() async {
  var response = await http.get(
      Uri.encodeFull("${appConfig.baseUrl}/api/positions"),
      headers: {"Accept": "application/json"});

  var json = jsonDecode(response.body);
  PositionResponse positionResponse = PositionResponse.fromJson(json);
  return positionResponse.data;
}

