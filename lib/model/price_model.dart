
import 'package:flutter_kickstart/model/product_in_category_model.dart';
import 'package:flutter_kickstart/model/uom_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'price_model.g.dart';

@JsonSerializable()
class Price {
  ProductCategory productCategory;
  int id;
  String variation;
  double price;
  double discount_dollar;
  OUM uom;

  Price(this.productCategory, this.id, this.variation, this.price, this.discount_dollar,this.uom);

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}
