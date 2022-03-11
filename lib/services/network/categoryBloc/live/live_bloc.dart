import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  LiveBloc({required this.apiRepository}) : super(const LiveState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<LiveEvent, LiveState>> transformEvents(
    Stream<LiveEvent> events,
    TransitionFunction<LiveEvent, LiveState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<LiveState> mapEventToState(LiveEvent event) async* {
    if (event is LiveFetched) {
      yield await _mapPostToState(state);
    } else if (event is LiveReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: LiveStatus.initial));
    }
  }

  Future<LiveState> _mapPostToState(LiveState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == LiveStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: LiveStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: LiveStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: LiveStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(7, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
