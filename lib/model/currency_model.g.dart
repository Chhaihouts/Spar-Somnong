// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) {
  return CurrencyModel(
    key: json['key'] as String,
    id: json['id'] as int,
    name: json['name'] as String,
    amount: json['amount'] as double,
  );
}

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
    };

CurrencyResponse _$CurrencyResponseFromJson(Map<String, dynamic> json) {
  return CurrencyResponse(
    json['message'] as String,
    (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k,
          e == null ? null : CurrencyModel.fromJson(e as Map<String, dynamic>)),
    ),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$CurrencyResponseToJson(CurrencyResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
