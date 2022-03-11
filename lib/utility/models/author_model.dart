import 'package:json_annotation/json_annotation.dart';
part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel {
  final int id;
  final String name;
  final String imageUrl;

  AuthorModel({required this.id, required this.name, required this.imageUrl});

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
}
