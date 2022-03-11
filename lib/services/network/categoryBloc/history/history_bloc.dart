import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({required this.apiRepository}) : super(const HistoryState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<HistoryEvent, HistoryState>> transformEvents(
    Stream<HistoryEvent> events,
    TransitionFunction<HistoryEvent, HistoryState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    if (event is HistoryFetched) {
      yield await _mapPostToState(state);
    } else if (event is HistoryReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: HistoryStatus.initial));
    }
  }

  Future<HistoryState> _mapPostToState(HistoryState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == HistoryStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: HistoryStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: HistoryStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: HistoryStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(6, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
