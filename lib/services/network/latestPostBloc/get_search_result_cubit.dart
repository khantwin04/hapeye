import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';

part 'get_search_result_state.dart';

class GetSearchResultCubit extends Cubit<GetSearchResultState> {
  final WpRepsitory wp;
  GetSearchResultCubit(this.wp) : super(GetSearchResultInitial());

  List<PostModel> searchList = [];

  void addSearchList(List<PostModel> _postList) {
    searchList.addAll(_postList);
  }

  List<PostModel> getAllSearchList() {
    return [...searchList];
  }

  void searchPost(String searchText, int page) async {
    if (page == 1) searchList.clear();
    emit(GetSearchResultLoading());
    wp.searchPost(searchText, page).then((value) async {
      addSearchList(value);
      emit(GetSearchResultSuccess());
    }).catchError((e) {
      if (page == 1)
        emit(GetSearchResultFail(e.toString()));
      else
        emit(GetSearchResultSuccess());
    });
  }
}
