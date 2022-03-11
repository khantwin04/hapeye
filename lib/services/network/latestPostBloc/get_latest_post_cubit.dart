import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utility/models/post_model.dart';
import '../../repo/repo.dart';

part 'get_latest_post_state.dart';

class GetLatestPostCubit extends Cubit<GetLatestPostState> {
  final WpRepsitory wp;

  GetLatestPostCubit(this.wp) : super(GetLatestPostInitial()) {
    getLatestPost(1);
  }

  List<PostModel> postList = [];

  List<PostModel> filterPostList = [];

  List<PostModel> searchList = [];

  set addPostToList(List<PostModel> _postList) {
    postList.addAll(_postList);
  }

  List<PostModel> get getAllPost => [...postList];

  void addFilterPost(List<PostModel> _postList) {
    filterPostList.addAll(_postList);
  }

  List<PostModel> getAllFilterPost() {
    return [...filterPostList];
  }

  void addSearchList(List<PostModel> _postList) {
    searchList.addAll(_postList);
  }

  List<PostModel> getAllSearchList() {
    return [...searchList];
  }

  void searchPost(String searchText, int page) async {
    if (page == 1) searchList.clear();
    emit(GetLatestPostLoading());
    wp.searchPost(searchText, page).then((value) async {
      addSearchList(value);
      emit(GetLatestPostSuccess(postList));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else
        emit(GetLatestPostSuccess(postList));
    });
  }

  void getLatestPost(int page) async {
    emit(GetLatestPostLoading());
    wp.getLatestPost(page).then((value) async {
      print(value.length);
      addPostToList = value;
      emit(GetLatestPostSuccess(value));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else {
        emit(GetLatestPostSuccess([]));
      }
    });
  }

  void getPostByCategory(int id, int page) async {
    if (page == 1) filterPostList.clear();
    emit(GetLatestPostLoading());
    wp.getPostByCategory(id, page).then((value) async {
      addFilterPost(value);
      emit(GetLatestPostSuccess(postList));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else
        emit(GetLatestPostSuccess(postList));
    });
  }
}
