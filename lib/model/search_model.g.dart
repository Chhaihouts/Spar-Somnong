// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search(
    json['id'] as int,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['icon'] as String,
  );
}

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'id': instance.id,
      'name_kh': instance.name_kh,
      'name_en': instance.name_en,
      'name_ch': instance.name_ch,
      'icon': instance.icon,
    };

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) {
  return SearchResponse(
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Search.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
