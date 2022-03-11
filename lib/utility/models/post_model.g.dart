// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  String date = DateFormat('dd MMMM, yyyy', 'en_US')
      .format(DateTime.parse(json["date"]))
      .toString();

  return PostModel(
    id: json['id'] as int,
    date: json['date'],
    link: json['link'] as String,
    title: json['title']['rendered'] as String,
    excerpt: json['excerpt']['rendered'] as String,
    categories:
        (json['categories'] as List<dynamic>).map((e) => e as int).toList(),
    tags: (json['tags'] as List<dynamic>).map((e) => e as int).toList(),
    author: json['author'] as int,
    featured_media: json['featured_media'] as int,
    authorName: json['_embedded']['author'][0]['name'] as String?,
    authorImageUrl:
        json['_embedded']['author'][0]['avatar_urls']['96'] as String?,
    imageUrl: json['_embedded']['wp:featuredmedia'][0]['source_url'] as String?,
    categoryNameList: (json['categoryNameList'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    tagNameList: (json['tagNameList'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'link': instance.link,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'categories': instance.categories,
      'tags': instance.tags,
      'author': instance.author,
      'featured_media': instance.featured_media,
      'authorName': instance.authorName,
      'authorImageUrl': instance.authorImageUrl,
      'imageUrl': instance.imageUrl,
      'categoryNameList': instance.categoryNameList,
      'tagNameList': instance.tagNameList,
    };
