import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'it_event.dart';
part 'it_state.dart';

class ItBloc extends Bloc<ItEvent, ItState> {
  ItBloc({required this.apiRepository}) : super(const ItState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<ItEvent, ItState>> transformEvents(
    Stream<ItEvent> events,
    TransitionFunction<ItEvent, ItState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ItState> mapEventToState(ItEvent event) async* {
    if (event is ItFetched) {
      yield await _mapPostToState(state);
    } else if (event is ItReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: ItStatus.initial));
    }
  }

  Future<ItState> _mapPostToState(ItState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == ItStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: ItStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ItStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: ItStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(12, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
