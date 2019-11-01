import 'package:json_annotation/json_annotation.dart';
part 'position_model.g.dart';

class Status {
  bool success;
  int code;
  String message;
  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class Position {
  int id;
  String name_kh;
  String name_en;
  String name_ch;

  Position(this.id, this.name_kh, this.name_en, this.name_ch);

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);

}

@JsonSerializable()
class PositionResponse extends Status {
  List<Position> data;

  PositionResponse(
      String message,
      this.data,
      bool success,
      int code,
      ) : super(message, success, code);

  factory PositionResponse.fromJson(Map<String, dynamic> json) =>
      _$PositionResponseFromJson(json);
}
