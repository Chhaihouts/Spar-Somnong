// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    token: json['token'] as String,
    id: json['id'] as int,
    client_id: json['client_id'] as int,
    uid: json['uid'] as String,
    name: json['name'] as String,
    position_id: json['position_id'] as int,
    phone: json['phone'] as String,
    email: json['email'] as String,
    photo: json['photo'] as String,
    position: json['position'] == null
        ? null
        : Position.fromJson(json['position'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'token': instance.token,
      'id': instance.id,
      'client_id': instance.client_id,
      'uid': instance.uid,
      'name': instance.name,
      'position_id': instance.position_id,
      'phone': instance.phone,
      'email': instance.email,
      'photo': instance.photo,
      'position': instance.position,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) {
  return UserResponse(
    json['message'] as String,
    json['data'] == null
        ? null
        : UserModel.fromJson(json['data'] as Map<String, dynamic>),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
