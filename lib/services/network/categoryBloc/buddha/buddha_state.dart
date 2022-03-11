part of 'buddha_bloc.dart';

enum BuddhaStatus { initial, success, failure }

class BuddhaState extends Equatable {
  const BuddhaState({
    this.status = BuddhaStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final BuddhaStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  BuddhaState copyWith({
    BuddhaStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return BuddhaState(
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
