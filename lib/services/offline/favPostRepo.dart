import 'package:news/utility/models/post_model.dart';
import 'favPostDao.dart';

class FavpostRepository {
  final favpostDao = FavpostDao();

  Future getAllFavpost({String? query, int? page}) =>
      favpostDao.getFavposts(query: query, page: page);

  Future getFavpost(int id) => favpostDao.getFavpost(id);

  Future insertFavpost(PostModel postModel) =>
      favpostDao.createFavpost(postModel);

  Future deleteFavpostById(int id) => favpostDao.deleteFavpost(id);
}
