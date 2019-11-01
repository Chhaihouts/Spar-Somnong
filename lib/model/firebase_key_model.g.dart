// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireBaseKeyResponse _$FireBaseKeyResponseFromJson(Map<String, dynamic> json) {
  return FireBaseKeyResponse(
    json['key'] as String,
    (json['users'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : User.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$FireBaseKeyResponseToJson(
        FireBaseKeyResponse instance) =>
    <String, dynamic>{
      'key': instance.key,
      'users': instance.users,
    };
