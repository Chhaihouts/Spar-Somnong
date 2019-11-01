// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prode_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) {
  return ProductDetail(
    json['id'] as int,
    json['item_img'] as String,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['description_en'] as String,
    json['description_kh'] as String,
    json['description_ch'] as String,
    json['specification_en'] as String,
    json['specification_kh'] as String,
    json['specification_ch'] as String,
    json['categories_id'] as int,
    json['vdo_url'] as String,
    (json['prices'] as List)
        ?.map(
            (e) => e == null ? null : Price.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['mobile'] as List)
        ?.map((e) =>
            e == null ? null : Mobile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..view_cnt = json['view_cnt'] as int;
}

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_img': instance.item_img,
      'name_en': instance.name_en,
      'name_kh': instance.name_kh,
      'name_ch': instance.name_ch,
      'description_en': instance.description_en,
      'description_kh': instance.description_kh,
      'description_ch': instance.description_ch,
      'specification_en': instance.specification_en,
      'specification_kh': instance.specification_kh,
      'specification_ch': instance.specification_ch,
      'categories_id': instance.categories_id,
      'vdo_url': instance.vdo_url,
      'view_cnt': instance.view_cnt,
      'prices': instance.prices,
      'mobile': instance.mobile,
    };

ProductDetailResponse _$ProductDetailResponseFromJson(
    Map<String, dynamic> json) {
  return ProductDetailResponse(
    json['message'] as String,
    json['data'] == null
        ? null
        : ProductDetail.fromJson(json['data'] as Map<String, dynamic>),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$ProductDetailResponseToJson(
        ProductDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
