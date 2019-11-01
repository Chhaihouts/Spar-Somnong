import 'dart:convert';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var appConfig = Config.fromJson(config);

Future<List<Category>> getAllCategory() async {
  final response = await http.get("${appConfig.baseUrl}/api/categories");

  print("base ur ${appConfig.baseUrl}");

  var json = jsonDecode(response.body);
  CategoryResponse categoryResponse = CategoryResponse.fromJson(json);
  return categoryResponse.data;
}

Future<List<Category>> categoriesClient(int page, int limit) async {
  var response = await http.get(
      Uri.encodeFull("${appConfig.baseUrl}/api/categories?page=$page&limit=$limit"),
      headers: {"Accept": "application/json"});

  var json = jsonDecode(response.body);
  CategoryResponse categoryResponse = CategoryResponse.fromJson(json);
  return categoryResponse.data;

}

//Future<Post> createPost(Post post) async{
//  final response = await http.post('$url',
//      headers: {
//        HttpHeaders.contentTypeHeader: 'application/json'
//      },
//      body: postToJson(post)
//  );
//
//  return postFromJson(response.body);
//}
