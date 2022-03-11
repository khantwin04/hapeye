part of 'live_bloc.dart';

enum LiveStatus { initial, success, failure }

class LiveState extends Equatable {
  const LiveState({
    this.status = LiveStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final LiveStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  LiveState copyWith({
    LiveStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return LiveState(
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
