import 'package:news/utility/models/category_model.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final int id;
  final String date;
  final String link;
  final String title;
  final String excerpt;
  final List<int> categories;
  final List<int> tags;
  final int author;
  final int featured_media;
  String? authorName;
  String? authorImageUrl;
  String? imageUrl;
  List<String>? categoryNameList;
  List<String>? tagNameList;

  PostModel({
    required this.id,
    required this.date,
    required this.link,
    required this.title,
    required this.excerpt,
    required this.categories,
    required this.tags,
    required this.author,
    required this.featured_media,
    this.authorName,
    this.authorImageUrl,
    this.imageUrl,
    this.categoryNameList,
    this.tagNameList,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  factory PostModel.fromDatabaseJson(Map<String, dynamic> data) => PostModel(
        id: data['id'],
        title: data['title'],
        imageUrl: data['image'],
        categoryNameList: [],
        date: data['date'],
        link: data['link'],
        author: 0,
        categories: [int.parse(data['content'])],
        excerpt: data['excerpt'],
        featured_media: 0,
        tags: [],
        authorName: data['authorName'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'title': this.title,
        'content': this.categories[0].toString(),
        'image': this.imageUrl,
        'date': this.date,
        'link': this.link,
        'authorName': this.authorName,
        'excerpt': this.excerpt,
      };
}
