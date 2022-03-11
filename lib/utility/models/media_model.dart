import 'package:json_annotation/json_annotation.dart';
part 'media_model.g.dart';

@JsonSerializable()
class MediaModel {
  final int id;
  final String link;

  MediaModel({required this.id, required this.link});

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);
}
