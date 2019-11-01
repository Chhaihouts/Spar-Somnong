import 'package:flutter_kickstart/model/position_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class UserModel {
  String token;
  int id;
  int client_id;
  String uid;
  String name;
  int position_id;
  String phone;
  String email;
  String photo;
  Position position;

  UserModel({
    this.token,
    this.id,
    this.client_id,
    this.uid,
    this.name,
    this.position_id,
    this.phone,
    this.email,
    this.photo,
    this.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserResponse extends Status {
  UserModel data;
  UserResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
