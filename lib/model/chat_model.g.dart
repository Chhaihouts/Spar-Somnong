// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastMessage _$LastMessageFromJson(Map<dynamic, dynamic> json) {
  return LastMessage(
    json['data'] as String,
    json['key'] as String,
    json['type'] as int,
  );
}

Map<dynamic, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'data': instance.data,
      'key': instance.key,
      'type': instance.type,
    };

Message _$MessageFromJson(Map<dynamic, dynamic> json) {
  return Message(
    json['data'] as String,
    json['lastTimeStamp'] as int,
    json['type'] as int,
  );
}

Map<dynamic, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'data': instance.data,
      'lastTimeStamp': instance.lastTimeStamp,
      'type': instance.type,
    };

User _$UserFromJson(Map<dynamic, dynamic> json) {
  return User(
    json['lastSeen'] as String,
    json['userId'] as int,
  );
}

Map<dynamic, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'lastSeen': instance.lastSeen,
      'userId': instance.userId,
    };

Messages _$MessagesFromJson(Map<dynamic, dynamic> json) {
  return Messages(
    json['key'] as String,
    json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<dynamic, dynamic>),
    json['userId'] as int,
  );
}

Map<dynamic, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'key': instance.key,
      'message': instance.message,
      'userId': instance.userId,
};

ChatResponse _$ChatResponseFromJson(Map<dynamic, dynamic> json) {
  return ChatResponse(
    json['key'] as String,
    json['lastMessage'] == null
        ? null
        : LastMessage.fromJson(json['lastMessage'] as Map<dynamic, dynamic>),
    json['lastTimeStamp'] as int,
    (json['messages'] as Map<dynamic, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Messages.fromJson(e as Map<dynamic, dynamic>)),
    ),
    (json['users'] as Map<dynamic, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : User.fromJson(e as Map<dynamic, dynamic>)),
    ),
  );
}

Map<dynamic, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'key': instance.key,
      'lastMessage': instance.lastMessage,
      'lastTimeStamp': instance.lastTimeStamp,
      'messages': instance.messages,
      'users': instance.users,
    };
