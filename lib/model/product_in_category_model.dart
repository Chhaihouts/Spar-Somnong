import 'package:flutter_kickstart/model/price_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_in_category_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class ProductCategory {
  int id;
  String item_img;
  String name_kh;
  String name_en;
  String name_ch;
  String vdo_url;
  List<Price> prices;

  ProductCategory(this.id, this.item_img, this.name_kh, this.name_en,
      this.name_ch, this.vdo_url, this.prices);

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

@JsonSerializable()
class ProductCategoryResponse extends Status {
  List<ProductCategory> data;

  ProductCategoryResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory ProductCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryResponseFromJson(json);
}
