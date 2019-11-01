// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastChat _$LastChatFromJson(Map<String, dynamic> json) {
  return LastChat(
    json['id'] as int,
    json['user_id'] as int,
    json['item_id'] as int,
    json['client_id'] as int,
    json['chat_key'] as String,
    json['product'] == null
        ? null
        : ProductCategory.fromJson(json['product'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LastChatToJson(LastChat instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'item_id': instance.item_id,
      'client_id': instance.client_id,
      'chat_key': instance.chat_key,
      'product': instance.product,
      'user': instance.user,
    };

LastChatResponse _$LastChatResponseFromJson(Map<String, dynamic> json) {
  return LastChatResponse(
    json['message'] as String,
    json['data'] == null
        ? null
        : LastChat.fromJson(json['data'] as Map<String, dynamic>),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$LastChatResponseToJson(LastChatResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
