import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'philo_event.dart';
part 'philo_state.dart';

class PhiloBloc extends Bloc<PhiloEvent, PhiloState> {
  PhiloBloc({required this.apiRepository}) : super(const PhiloState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<PhiloEvent, PhiloState>> transformEvents(
    Stream<PhiloEvent> events,
    TransitionFunction<PhiloEvent, PhiloState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PhiloState> mapEventToState(PhiloEvent event) async* {
    if (event is PhiloFetched) {
      yield await _mapPostToState(state);
    } else if (event is PhiloReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: PhiloStatus.initial));
    }
  }

  Future<PhiloState> _mapPostToState(PhiloState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == PhiloStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: PhiloStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PhiloStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: PhiloStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(9, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
