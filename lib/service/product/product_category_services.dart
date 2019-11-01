import 'dart:convert';
import 'dart:io';

import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/category_model.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var appConfig = Config.fromJson(config);

Future<List<Category>> getAllProductCategory() async {
  final response =
      await http.get("${appConfig.baseUrl}/api/categories/1/products?page=1");
  var json = jsonDecode(response.body);
  CategoryResponse categoryResponse = CategoryResponse.fromJson(json);
  return categoryResponse.data;
}

Future<List<ProductCategory>> productCategoriesClient(
    int categoryId, int pageId, int limit) async {
  var uri = Uri.encodeFull(
      '${appConfig.baseUrl}/api/categories/$categoryId/products?page=$pageId&limit=$limit');

  var response = await http
      .get(uri, headers: {HttpHeaders.contentTypeHeader: "application/json"});

  var json = jsonDecode(response.body);
  ProductCategoryResponse productCategoryResponse =
      ProductCategoryResponse.fromJson(json);
  return productCategoryResponse.data;
}

Future<List<ProductCategory>> searchProduct(
    String keyword, int page, int limit) async {
  var uri = Uri.encodeFull(
      '${appConfig.baseUrl}/api/products?keyword=$keyword&page=$page&limit=$limit');
  var response = await http
      .get(uri, headers: {HttpHeaders.contentTypeHeader: "application/json"});
  var json = jsonDecode(response.body);
  ProductCategoryResponse productCategoryResponse =
      ProductCategoryResponse.fromJson(json);
  return productCategoryResponse.data;
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