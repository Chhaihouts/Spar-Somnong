import 'package:flutter_kickstart/model/mobile_model.dart';
import 'package:flutter_kickstart/model/price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favourite_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class Favourite {
  int id;
  String item_img;
  String name_en;
  String name_kh;
  String name_ch;
  String vdo_url;

  Favourite(this.id, this.item_img, this.name_kh, this.name_en, this.name_ch,
      this.vdo_url);

  factory Favourite.fromJson(Map<String, dynamic> json) =>
      _$FavouriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavouriteToJson(this);
}

@JsonSerializable()
class FavouriteResponse extends Status {
  List<Favourite> data;

  FavouriteResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory FavouriteResponse.fromJson(Map<String, dynamic> json) =>
      _$FavouriteResponseFromJson(json);
}
