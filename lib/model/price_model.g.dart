// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) {
  return Price(
    json['productCategory'] == null
        ? null
        : ProductCategory.fromJson(
            json['productCategory'] as Map<String, dynamic>),
    json['id'] as int,
    json['variation'] as String,
    (json['price'] as num)?.toDouble(),
    (json['discount_dollar'] as num)?.toDouble(),
    json['uom'] == null
        ? null
        : OUM.fromJson(json['uom'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'productCategory': instance.productCategory,
      'id': instance.id,
      'variation': instance.variation,
      'price': instance.price,
      'discount_dollar': instance.discount_dollar,
      'uom': instance.uom,
    };
