import 'package:news/utility/models/post_model.dart';
import 'readPostDao.dart';

class ReadPostRepository {
  final readPostDao = ReadPostDao();

  Future getAllReadPost({String? query, int? page}) =>
      readPostDao.getReadPosts(query: query, page: page);

  Future getReadPost(int id) => readPostDao.getReadPost(id);

  Future insertReadPost(PostModel postModel) =>
      readPostDao.createReadpost(postModel);

  Future deleteReadPostById(int id) => readPostDao.deleteReadPost(id);

  Future deleteAll() => readPostDao.deleteAll();
}
