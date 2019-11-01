import 'package:json_annotation/json_annotation.dart';
part 'uom_model.g.dart';

@JsonSerializable()
class OUM {
  int id;
  String name_en;
  String name_kh;
  String name_ch;

  OUM(this.id, this.name_en, this.name_ch, this.name_kh);
  factory OUM.fromJson(Map<String, dynamic> json) =>
      _$OUMFromJson(json);

  Map<String, dynamic> toJson() => _$OUMToJson(this);
}