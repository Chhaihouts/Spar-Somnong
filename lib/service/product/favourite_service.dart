import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/favourite_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var appConfig = Config.fromJson(config);

Future<List<Favourite>> getFavourite(int page, int limit) async {
  var authResult = await FirebaseAuth.instance.currentUser();
  var token = authResult.getIdToken(refresh: true);

  final response = await http.get(
      "${appConfig.baseUrl}/api/auth/me/favorite?page=$page&limit=$limit",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token.token}"
      });

  var json = jsonDecode(response.body);
  FavouriteResponse favouriteResponse = FavouriteResponse.fromJson(json);
  return favouriteResponse.data;
}

Future<List<Favourite>> getFavouriteClient(int page, int limit) async {
  var authResult = await FirebaseAuth.instance.currentUser();
  var token = await authResult.getIdToken(refresh: true);

  final response = await http.get(
      "${appConfig.baseUrl}/api/auth/me/favorite?page=$page&limit=$limit",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${token.token}"
      });

  var json = jsonDecode(response.body);
  FavouriteResponse favouriteResponse = FavouriteResponse.fromJson(json);
  return favouriteResponse.data;
}

Future<FavouriteResponse> deleteFavourite(int id) async {
  var authResult = await FirebaseAuth.instance.currentUser();
  var token = await authResult.getIdToken(refresh: true);

  final response = await http
      .delete("${appConfig.baseUrl}/api/auth/me/favorite/$id", headers: {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${token.token}"
  });

  var json = jsonDecode(response.body);
  FavouriteResponse favouriteResponse = FavouriteResponse.fromJson(json);
  return favouriteResponse;
}

Future<FavouriteResponse> isFavourite(int id) async {
  var authResult = await FirebaseAuth.instance.currentUser();
  var token = await authResult.getIdToken(refresh: true);

  final response = await http.get("${appConfig.baseUrl}/api/auth/me/favorite/$id", headers: {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${token.token}"
  });

  var json = jsonDecode(response.body);
  FavouriteResponse favouriteResponse = FavouriteResponse.fromJson(json);
  return favouriteResponse;
}

Future<FavouriteResponse> addFavourite(int productId) async {
  var authResult = await FirebaseAuth.instance.currentUser();
  var token = await authResult.getIdToken(refresh: true);

  final response = await http.post("${appConfig.baseUrl}/api/auth/me/favorite",
      body: jsonEncode({'product_id': productId}),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${token.token}"
      });

  var json = jsonDecode(response.body);
  FavouriteResponse favouriteResponse = FavouriteResponse.fromJson(json);
  return favouriteResponse;
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
