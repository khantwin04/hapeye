import 'dart:async';
import 'package:news/utility/models/post_model.dart';

import 'favPostDb.dart';

class FavpostDao {
  final dbProvider = FavpostDatabaseProvider.dbProvider;

  Future<int> createFavpost(PostModel post) async {
    final db = await dbProvider.database;

    var result = await db.insert(favpostTABLE, post.toDatabaseJson());
    return result;
  }

  Future<List<PostModel>> getFavposts(
      {List<String>? columns, String? query, int? page}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(
          favpostTABLE,
          columns: columns,
          where: 'name LIKE ?',
          whereArgs: ["%$query%"],
        );
    } else {
      result = await db.query(favpostTABLE, columns: columns);
    }

    List<PostModel> posts = result!.isNotEmpty
        ? result.map((item) => PostModel.fromDatabaseJson(item)).toList()
        : [];
    return posts;
  }

  Future<PostModel> getFavpost(int id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>>? maps =
        await db.query(favpostTABLE, where: 'id = ?', whereArgs: [id]);
    print(maps.length);

    PostModel post = maps.length > 0
        ? PostModel.fromDatabaseJson(maps.first)
        : PostModel(
            id: 0000,
            date: '',
            link: '',
            title: 'title',
            excerpt: 'excerpt',
            categories: [],
            tags: [],
            author: 0,
            featured_media: 0);
    return post;
  }

  Future<int> deleteFavpost(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(favpostTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
