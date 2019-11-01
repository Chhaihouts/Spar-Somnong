// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) {
  return Position(
    json['id'] as int,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
  );
}

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'name_kh': instance.name_kh,
      'name_en': instance.name_en,
      'name_ch': instance.name_ch,
    };

PositionResponse _$PositionResponseFromJson(Map<String, dynamic> json) {
  return PositionResponse(
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Position.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$PositionResponseToJson(PositionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
