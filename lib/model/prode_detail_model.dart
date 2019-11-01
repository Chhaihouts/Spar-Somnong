import 'package:flutter_kickstart/model/mobile_model.dart';
import 'package:flutter_kickstart/model/price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prode_detail_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class ProductDetail {
  int id;
  String item_img;
  String name_en;
  String name_kh;
  String name_ch;
  String description_en;
  String description_kh;
  String description_ch;
  String specification_en;
  String specification_kh;
  String specification_ch;
  int categories_id;
  String vdo_url;
  int view_cnt;
  List<Price> prices;
  List<Mobile> mobile;

  ProductDetail(
      this.id,
      this.item_img,
      this.name_kh,
      this.name_en,
      this.name_ch,
      this.description_en,
      this.description_kh,
      this.description_ch,
      this.specification_en,
      this.specification_kh,
      this.specification_ch,
      this.categories_id,
      this.vdo_url,
      this.prices,
      this.mobile);

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}

@JsonSerializable()
class ProductDetailResponse extends Status {
  ProductDetail data;

  ProductDetailResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailResponseFromJson(json);
}
