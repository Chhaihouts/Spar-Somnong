// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
    title: json['title'] as String,
    level: json['level'] as String,
    indicatorValue: (json['indicatorValue'] as num)?.toDouble(),
    price: json['price'] as int,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'title': instance.title,
      'level': instance.level,
      'indicatorValue': instance.indicatorValue,
      'price': instance.price,
      'content': instance.content,
    };
