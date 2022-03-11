import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'buddha_event.dart';
part 'buddha_state.dart';

class BuddhaBloc extends Bloc<BuddhaEvent, BuddhaState> {
  BuddhaBloc({required this.apiRepository}) : super(const BuddhaState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<BuddhaEvent, BuddhaState>> transformEvents(
    Stream<BuddhaEvent> events,
    TransitionFunction<BuddhaEvent, BuddhaState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<BuddhaState> mapEventToState(BuddhaEvent event) async* {
    if (event is BuddhaFetched) {
      yield await _mapPostToState(state);
    } else if (event is BuddhaReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: BuddhaStatus.initial));
    }
  }

  Future<BuddhaState> _mapPostToState(BuddhaState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == BuddhaStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: BuddhaStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BuddhaStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } catch (e) {
      print(e.toString());
      return state.copyWith(status: BuddhaStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(5, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
