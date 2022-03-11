import 'package:news/utility/models/author_model.dart';
import 'package:news/utility/models/media_model.dart';
import 'package:news/utility/models/post_detail_model.dart';
import 'package:news/utility/models/tag_model.dart';

import '../utility/models/category_model.dart';
import '../utility/models/post_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api.g.dart';

@RestApi(baseUrl: 'https://hapeye.net/wp-json/wp/v2/')
abstract class Api {
  factory Api(Dio dio) => _Api(dio);

  @GET(
      'categories?page={page}&per_page=20&_fields=id,count,description,name,link')
  Future<List<CategoryModel>> getAllCategory(@Path() int page);

  @GET('categories?post={postId}&_fields=id,count,description,name,link')
  Future<List<CategoryModel>> getCategoryByPostId(@Path() int postId);

  @GET('tags?post={postId}&_fields=id,count,description,name,link')
  Future<List<TagModel>> getTagByPostId(@Path() int postId);

  @GET('posts?_embed&status=publish&per_page=10&page={page}')
  Future<List<PostModel>> getLatestPost(@Path() int page);

  @GET('users/{authorId}?_fields=id,name,avatar_urls')
  Future<AuthorModel> getAuthor(@Path() int authorId);

  @GET('media/{mediaId}?_fields=id,guid')
  Future<MediaModel> getMedia(@Path() int mediaId);

  @GET('posts/{postId}?status=publish&_fields=id,content')
  Future<PostDetailModel> getPostDetail(@Path() int postId);

  @GET('posts?_embed&categories[]={id}&status=publish&per_page=10&page={page}')
  Future<List<PostModel>> getPostByCategory(@Path() int id, @Path() int page);

  @GET(
      'posts?_embed&search={searchText}&status=publish&per_page=10&page={page}')
  Future<List<PostModel>> searchPost(
      @Path() String searchText, @Path() int page);
}
