part of 'history_bloc.dart';

enum HistoryStatus { initial, success, failure }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final HistoryStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  HistoryState copyWith({
    HistoryStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return HistoryState(
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
