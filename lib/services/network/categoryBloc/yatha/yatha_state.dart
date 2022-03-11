part of 'yatha_bloc.dart';

enum YathaStatus { initial, success, failure }

class YathaState extends Equatable {
  const YathaState({
    this.status = YathaStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final YathaStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  YathaState copyWith({
    YathaStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return YathaState(
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
