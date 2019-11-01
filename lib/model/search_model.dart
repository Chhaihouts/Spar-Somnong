import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class Search{
  int id;
  String name_kh;
  String name_en;
  String name_ch;
  String icon;

  Search(this.id, this.name_kh, this.name_en, this.name_ch, this.icon);

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}

@JsonSerializable()
class SearchResponse extends Status {
  List<Search> data;

  SearchResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
