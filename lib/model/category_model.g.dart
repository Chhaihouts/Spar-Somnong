// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['id'] as int,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['icon'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name_kh': instance.name_kh,
      'name_en': instance.name_en,
      'name_ch': instance.name_ch,
      'icon': instance.icon,
    };

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) {
  return CategoryResponse(
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['success'] as bool,
    json['code'] as int,
    json['count'] as int,
  );
}

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'count': instance.count,
      'data': instance.data,
    };
