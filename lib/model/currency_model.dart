import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class CurrencyModel {
  String key;
  int id;
  String name;
  double amount;

  CurrencyModel({this.key, this.id, this.name, this.amount});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);
}

@JsonSerializable()
class CurrencyResponse extends Status {
  Map<dynamic, CurrencyModel> data;
  CurrencyResponse(String message, this.data, bool success, int code,) : super(message, success, code);

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseFromJson(json);
}
