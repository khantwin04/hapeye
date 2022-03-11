// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) {
  return TagModel(
    id: json['id'] as int,
    count: json['count'] as int,
    name: json['name'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'name': instance.name,
      'link': instance.link,
    };
