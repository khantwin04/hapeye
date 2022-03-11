import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/services/repo/repo.dart';
import 'package:news/utility/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc({required this.apiRepository}) : super(const BusinessState());

  final WpRepsitory apiRepository;

  @override
  Stream<Transition<BusinessEvent, BusinessState>> transformEvents(
    Stream<BusinessEvent> events,
    TransitionFunction<BusinessEvent, BusinessState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    if (event is BusinessFetched) {
      yield await _mapPostToState(state);
    } else if (event is BusinessReload) {
      yield await _mapPostToState(state.copyWith(
          postList: [], hasReachedMax: false, status: BusinessStatus.initial));
    }
  }

  Future<BusinessState> _mapPostToState(BusinessState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == BusinessStatus.initial) {
        final postList = await _fetchAllPost();
        return state.copyWith(
          status: BusinessStatus.success,
          postList: postList,
          hasReachedMax: false,
        );
      }
      final postList = await _fetchAllPost();
      return postList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BusinessStatus.success,
              postList: List.of(state.postList)..addAll(postList),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: BusinessStatus.failure);
    }
  }

  set setPage(data) => page = data;

  int page = 1;

  Future<List<PostModel>> _fetchAllPost() async {
    print('Page value $page');
    try {
      List<PostModel> data = await apiRepository.getPostByCategory(11, page++);
      List<PostModel> postList = data;
      return postList;
    } catch (e) {
      return [];
    }
  }
}
