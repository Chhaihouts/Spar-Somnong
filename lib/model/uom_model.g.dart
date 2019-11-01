// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OUM _$OUMFromJson(Map<String, dynamic> json) {
  return OUM(
    json['id'] as int,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['name_kh'] as String,
  );
}

Map<String, dynamic> _$OUMToJson(OUM instance) => <String, dynamic>{
      'id': instance.id,
      'name_en': instance.name_en,
      'name_kh': instance.name_kh,
      'name_ch': instance.name_ch,
    };
