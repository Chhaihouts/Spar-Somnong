// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_in_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return ProductCategory(
    json['id'] as int,
    json['item_img'] as String,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['vdo_url'] as String,
    (json['prices'] as List)
        ?.map(
            (e) => e == null ? null : Price.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_img': instance.item_img,
      'name_kh': instance.name_kh,
      'name_en': instance.name_en,
      'name_ch': instance.name_ch,
      'vdo_url': instance.vdo_url,
      'prices': instance.prices,
    };

ProductCategoryResponse _$ProductCategoryResponseFromJson(
    Map<String, dynamic> json) {
  return ProductCategoryResponse(
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : ProductCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$ProductCategoryResponseToJson(
        ProductCategoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
