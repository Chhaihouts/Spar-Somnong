import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

class Status {
  bool success;
  int code;
  String message;
  int count;

  Status(this.message, this.success, this.code, this.count);
}

@JsonSerializable()
class Category {
  int id;
  String name_kh;
  String name_en;
  String name_ch;
  String icon;

  Category(this.id, this.name_kh, this.name_en, this.name_ch, this.icon);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoryResponse extends Status {
  List<Category> data;

  CategoryResponse(
    String message,
    this.data,
    bool success,
    int code,
    int count,
  ) : super(message, success, code, count);

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}
