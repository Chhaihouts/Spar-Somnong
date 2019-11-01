// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_holder_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

placeholder _$placeholderFromJson(Map<String, dynamic> json) {
  return placeholder(
    json['userId'] as int,
    json['id'] as int,
    (json['title'] as num)?.toDouble(),
    json['body'] as String,
  );
}

Map<String, dynamic> _$placeholderToJson(placeholder instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };
