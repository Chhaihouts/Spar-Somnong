import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

class Status {
  bool success;
  int code;
  String message;

  Status(this.message, this.success, this.code);
}

@JsonSerializable()
class File {
  String type;
  String file;

  File({this.type, this.file});

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);

  Map<String, dynamic> toJson() => _$FileToJson(this);
}

@JsonSerializable()
class FileResponse extends Status {
  File data;

  FileResponse(
    String message,
    this.data,
    bool success,
    int code,
  ) : super(message, success, code);

  factory FileResponse.fromJson(Map<String, dynamic> json) =>
      _$FileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileResponseToJson(this);
}
