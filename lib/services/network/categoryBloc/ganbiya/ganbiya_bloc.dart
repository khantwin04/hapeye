import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'ganbiya_event.dart';
part 'ganbiya_state.dart';

class GanbiyaBloc extends Bloc<GanbiyaEvent, GanbiyaState> {
  GanbiyaBloc({required this.apiRepository}) : super(const GanbiyaState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<GanbiyaEvent, GanbiyaState>> transformEvents(
    Stream<GanbiyaEvent> events,
    TransitionFunction<GanbiyaEvent, GanbiyaState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GanbiyaState> mapEventToState(GanbiyaEvent event) async* {
    if (event is GanbiyaFetched) {
      yield await _mapPostToState(state);
    } else if (event is GanbiyaReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: GanbiyaStatus.initial));
    }
  }

  Future<GanbiyaState> _mapPostToState(GanbiyaState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == GanbiyaStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: GanbiyaStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: GanbiyaStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: GanbiyaStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(10, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
