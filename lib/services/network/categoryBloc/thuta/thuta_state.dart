part of 'thuta_bloc.dart';

enum ThutaStatus { initial, success, failure }

class ThutaState extends Equatable {
  const ThutaState({
    this.status = ThutaStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final ThutaStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  ThutaState copyWith({
    ThutaStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return ThutaState(
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
