import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(createToJson: false)
class Config {
  final String baseUrl;

  Config(this.baseUrl);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
