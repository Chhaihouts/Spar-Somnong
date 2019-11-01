import 'package:json_annotation/json_annotation.dart';
part 'place_holder_user_model.g.dart';

@JsonSerializable()
class placeholder {
  int userId;
  int id;
  double title;
  String body;


  placeholder(this.userId, this.id, this.title, this.body);

  factory placeholder.fromJson(Map<String, dynamic> json) => _$placeholderFromJson(json);

  Map<String, dynamic> toJson() => _$placeholderToJson(this);
}
