import 'package:flutter_kickstart/model/company_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_model.g.dart';

@JsonSerializable()
class Mobile {
  int id;
  int item_id;
  int company_phone_id;
  String phone;
  Company company;

  Mobile(this.id, this.item_id, this.company_phone_id, this.phone, this.company);

  factory Mobile.fromJson(Map<String, dynamic> json) => _$MobileFromJson(json);

  Map<String, dynamic> toJson() => _$MobileToJson(this);

}
