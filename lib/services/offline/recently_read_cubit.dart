import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/offline/readPostRepo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:news/utility/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'recently_read_state.dart';

class RecentlyReadCubit extends Cubit<RecentlyReadState> {
  final ReadPostRepository repo;
  RecentlyReadCubit(this.repo) : super(RecentlyReadInitial()) {
    getReadPosts();
  }

  Future<void> getReadPosts({String? query, int? page}) async {
    emit(RecentlyReadLoading());
    try {
      final List<PostModel> posts =
          await repo.getAllReadPost(query: query, page: page);
      emit(RecentlyReadSuccess(posts));
    } catch (e) {
      emit(RecentlyReadFail(e.toString()));
    }
  }

  getReadPost(int id) async {
    final PostModel post = await repo.getReadPost(id);
    return post;
  }

  addReadPost(PostModel post) async {
    await repo.insertReadPost(post);
    getReadPosts();
  }

  deleteReadPostById(int id) async {
    await repo.deleteReadPostById(id);
    getReadPosts();
  }

  deleteAll() async {
    await repo.deleteAll();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    getReadPosts();
  }
}
