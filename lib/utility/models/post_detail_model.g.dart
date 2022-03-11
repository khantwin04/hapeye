// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetailModel _$PostDetailModelFromJson(Map<String, dynamic> json) {
  return PostDetailModel(
    id: json['id'] as int,
    content: json['content']['rendered'] as String,
  );
}

Map<String, dynamic> _$PostDetailModelToJson(PostDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
    };
