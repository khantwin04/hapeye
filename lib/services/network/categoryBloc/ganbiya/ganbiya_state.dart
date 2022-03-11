part of 'ganbiya_bloc.dart';

enum GanbiyaStatus { initial, success, failure }

class GanbiyaState extends Equatable {
  const GanbiyaState({
    this.status = GanbiyaStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final GanbiyaStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  GanbiyaState copyWith({
    GanbiyaStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return GanbiyaState(
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
