// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) {
  return File(
    type: json['type'] as String,
    file: json['file'] as String,
  );
}

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
      'type': instance.type,
      'file': instance.file,
    };

FileResponse _$FileResponseFromJson(Map<String, dynamic> json) {
  return FileResponse(
    json['message'] as String,
    json['data'] == null
        ? null
        : File.fromJson(json['data'] as Map<String, dynamic>),
    json['success'] as bool,
    json['code'] as int,
  );
}

Map<String, dynamic> _$FileResponseToJson(FileResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
