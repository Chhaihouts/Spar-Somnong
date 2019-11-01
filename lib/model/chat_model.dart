import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class LastMessage {
  String data;
  String key;
  int type;

  LastMessage(this.data, this.key, this.type);

  factory LastMessage.fromJson(Map<dynamic, dynamic> json) =>
      _$LastMessageFromJson(json);

  Map<dynamic, dynamic> toJson() => _$LastMessageToJson(this);
}

@JsonSerializable()
class Message {
  String data;
  int lastTimeStamp;
  int type;

  Message(this.data, this.lastTimeStamp, this.type);

  factory Message.fromJson(Map<dynamic, dynamic> json) =>
      _$MessageFromJson(json);

  Map<dynamic, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class User {
  String lastSeen;
  int userId;

  User(this.lastSeen, this.userId);

  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Messages {
  String key;
  Message message;
  int userId;

  Messages(this.key, this.message, this.userId);

  factory Messages.fromJson(Map<dynamic, dynamic> json) =>
      _$MessagesFromJson(json);

  Map<dynamic, dynamic> toJson() => _$MessagesToJson(this);
}

@JsonSerializable()
class ChatResponse {
  String key;
  LastMessage lastMessage;
  int lastTimeStamp;
  Map<dynamic, Messages> messages;
  Map<dynamic, User> users;

  ChatResponse(this.key,this.lastMessage, this.lastTimeStamp, this.messages, this.users);

  factory ChatResponse.fromJson(Map<dynamic, dynamic> json) =>
      _$ChatResponseFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ChatResponseToJson(this);
}
