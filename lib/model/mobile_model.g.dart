// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mobile _$MobileFromJson(Map<String, dynamic> json) {
  return Mobile(
    json['id'] as int,
    json['item_id'] as int,
    json['company_phone_id'] as int,
    json['phone'] as String,
    json['company'] == null
        ? null
        : Company.fromJson(json['company'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MobileToJson(Mobile instance) => <String, dynamic>{
      'id': instance.id,
      'item_id': instance.item_id,
      'company_phone_id': instance.company_phone_id,
      'phone': instance.phone,
      'company': instance.company,
    };
