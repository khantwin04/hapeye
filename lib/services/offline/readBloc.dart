import 'dart:async';
import 'package:news/services/offline/readPostRepo.dart';
import 'package:news/utility/models/post_model.dart';

class ReadPostBloc {
  final _PostRepository = ReadPostRepository();

  final _postsController = StreamController<List<PostModel>>.broadcast();

  Stream<List<PostModel>> get posts => _postsController.stream;

  ReadPostBloc() {
    getReadPosts();
  }

  Future<List<PostModel>> getReadPosts({String? query, int? page}) async {
    final List<PostModel> posts =
        await _PostRepository.getAllReadPost(query: query, page: page);
    _postsController.sink.add(posts);
    return posts;
  }

  getReadPost(int id) async {
    final PostModel post = await _PostRepository.getReadPost(id);
    return post;
  }

  addReadPost(PostModel Post) async {
    await _PostRepository.insertReadPost(Post);
    getReadPosts();
  }

  deleteReadPostById(int id) async {
    _PostRepository.deleteReadPostById(id);
    getReadPosts();
  }

  dispose() {
    _postsController.close();
  }
}
