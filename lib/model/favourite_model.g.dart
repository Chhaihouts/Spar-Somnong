// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favourite _$FavouriteFromJson(Map<String, dynamic> json) {
  return Favourite(
    json['id'] as int,
    json['item_img'] as String,
    json['name_kh'] as String,
    json['name_en'] as String,
    json['name_ch'] as String,
    json['vdo_url'] as String,
  );
}

Map<String, dynamic> _$FavouriteToJson(Favourite instance) => <String, dynamic>{
      'id': instance.id,
      'item_img': instance.item_img,
      'name_en': instance.name_en,
      'name_kh': instance.name_kh,
      'name_ch': instance.name_ch,
      'vdo_url': instance.vdo_url,
    };

FavouriteResponse _$FavouriteResponseFromJson(Map<String, dynamic> json) {
  return FavouriteResponse(
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Favourite.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$FavouriteResponseToJson(FavouriteResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
