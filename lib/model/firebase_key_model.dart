import 'package:json_annotation/json_annotation.dart';

import 'chat_model.dart';
part 'firebase_key_model.g.dart';

@JsonSerializable()
class FireBaseKeyResponse {
  String key;
  Map<dynamic, User> users;

  FireBaseKeyResponse(this.key,this.users);

  factory FireBaseKeyResponse.fromJson(Map<dynamic, dynamic> json) =>
      _$FireBaseKeyResponseFromJson(json);

  Map<dynamic, dynamic> toJson() => _$FireBaseKeyResponseToJson(this);
}