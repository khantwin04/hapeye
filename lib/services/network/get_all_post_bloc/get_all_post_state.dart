part of 'get_all_post_bloc.dart';

enum GetAllPostStatus { initial, success, failure }

class GetAllPostState extends Equatable {
  const GetAllPostState({
    this.status = GetAllPostStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final GetAllPostStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  GetAllPostState copyWith({
    GetAllPostStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return GetAllPostState(
      status: status ?? this.status,
      postList: postList ?? this.postList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''UserState { status: $status, hasReachedMax: $hasReachedMax, posts: ${postList.length} }''';
  }

  @override
  List<Object> get props => [status, postList, hasReachedMax];
}
