import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'thuta_event.dart';
part 'thuta_state.dart';

class ThutaBloc extends Bloc<ThutaEvent, ThutaState> {
  ThutaBloc({required this.apiRepository}) : super(const ThutaState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<ThutaEvent, ThutaState>> transformEvents(
    Stream<ThutaEvent> events,
    TransitionFunction<ThutaEvent, ThutaState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ThutaState> mapEventToState(ThutaEvent event) async* {
    if (event is ThutaFetched) {
      yield await _mapPostToState(state);
    } else if (event is ThutaReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: ThutaStatus.initial));
    }
  }

  Future<ThutaState> _mapPostToState(ThutaState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == ThutaStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: ThutaStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ThutaStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: ThutaStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(1, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
