import 'package:news/utility/models/author_model.dart';
import 'package:news/utility/models/media_model.dart';
import 'package:news/utility/models/post_detail_model.dart';
import 'package:news/utility/models/tag_model.dart';

import '../../utility/models/category_model.dart';
import '../../utility/models/post_model.dart';
import '../../services/api.dart';

class WpRepsitory {
  final Api _api;
  WpRepsitory(this._api);

  Future<List<CategoryModel>> getAllCategory(int page) =>
      _api.getAllCategory(page);

  Future<List<CategoryModel>> getCategoryByPostId(int postId) =>
      _api.getCategoryByPostId(postId);

  Future<List<TagModel>> getTagByPostId(int postId) =>
      _api.getTagByPostId(postId);

  Future<AuthorModel> getAuthor(int authorId) => _api.getAuthor(authorId);

  Future<MediaModel> getMedia(int mediaId) => _api.getMedia(mediaId);

  Future<PostDetailModel> getPostDetail(int postId) =>
      _api.getPostDetail(postId);

  Future<List<PostModel>> getLatestPost(int page) => _api.getLatestPost(page);

  Future<List<PostModel>> getPostByCategory(int id, int page) =>
      _api.getPostByCategory(id, page);

  Future<List<PostModel>> searchPost(String searchText, int page) =>
      _api.searchPost(searchText, page);
}
