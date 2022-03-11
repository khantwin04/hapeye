import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'yatha_event.dart';
part 'yatha_state.dart';

class YathaBloc extends Bloc<YathaEvent, YathaState> {
  YathaBloc({required this.apiRepository}) : super(const YathaState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<YathaEvent, YathaState>> transformEvents(
    Stream<YathaEvent> events,
    TransitionFunction<YathaEvent, YathaState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<YathaState> mapEventToState(YathaEvent event) async* {
    if (event is YathaFetched) {
      yield await _mapPostToState(state);
    } else if (event is YathaReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: YathaStatus.initial));
    }
  }

  Future<YathaState> _mapPostToState(YathaState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == YathaStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: YathaStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: YathaStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: YathaStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(4, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
