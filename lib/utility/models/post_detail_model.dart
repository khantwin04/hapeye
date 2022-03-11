import 'package:json_annotation/json_annotation.dart';
part 'post_detail_model.g.dart';

@JsonSerializable()
class PostDetailModel {
  final int id;
  final String content;

  PostDetailModel({required this.id, required this.content});

  factory PostDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PostDetailModelFromJson(json);
}
