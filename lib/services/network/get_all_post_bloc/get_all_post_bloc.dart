import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'get_all_post_event.dart';
part 'get_all_post_state.dart';

class GetAllPostBloc extends Bloc<GetAllPostEvent, GetAllPostState> {
  GetAllPostBloc({required this.apiRepository})
      : super(const GetAllPostState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<GetAllPostEvent, GetAllPostState>> transformEvents(
    Stream<GetAllPostEvent> events,
    TransitionFunction<GetAllPostEvent, GetAllPostState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GetAllPostState> mapEventToState(GetAllPostEvent event) async* {
    if (event is GetAllPostFetched) {
      yield await _mapPostToState(state);
    } else if (event is GetAllPostReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [],
          hasReachedMax: false,
          status: GetAllPostStatus.initial));
    }
  }

  Future<GetAllPostState> _mapPostToState(GetAllPostState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == GetAllPostStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: GetAllPostStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: GetAllPostStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: GetAllPostStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    List<PostModel> data = await apiRepository.getLatestPost(page++);
    List<PostModel> postList = data;
    return postList;
  }
}
