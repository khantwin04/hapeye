import 'package:json_annotation/json_annotation.dart';
part 'tag_model.g.dart';

@JsonSerializable()
class TagModel {
  final int id;
  final int count;
  final String name;
  final String link;

  TagModel({required this.id, required this.count, required this.name, required this.link});

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}
