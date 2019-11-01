
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'last_chat_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class LastChat{
    int id;
    int user_id;
    int item_id;
    int client_id;
    String chat_key;
    ProductCategory product;
    UserModel user;

    LastChat(this.id, this.user_id, this.item_id, this.client_id, this.chat_key,
        this.product, this.user);

    factory LastChat.fromJson(Map<String, dynamic> json) => _$LastChatFromJson(json);

    Map<String, dynamic> toJson() => _$LastChatToJson(this);
}

@JsonSerializable()
class LastChatResponse extends Status {
  LastChat data;

  LastChatResponse(
      String message,
      this.data,
      bool success,
      int code,
      ) : super(message, success, code);

  factory LastChatResponse.fromJson(Map<String, dynamic> json) => _$LastChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LastChatResponseToJson(this);
}