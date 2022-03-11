import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  EducationBloc({required this.apiRepository}) : super(const EducationState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<EducationEvent, EducationState>> transformEvents(
    Stream<EducationEvent> events,
    TransitionFunction<EducationEvent, EducationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<EducationState> mapEventToState(EducationEvent event) async* {
    if (event is EducationFetched) {
      yield await _mapPostToState(state);
    } else if (event is EducationReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: EducationStatus.initial));
    }
  }

  Future<EducationState> _mapPostToState(EducationState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == EducationStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: EducationStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: EducationStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: EducationStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(8, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
