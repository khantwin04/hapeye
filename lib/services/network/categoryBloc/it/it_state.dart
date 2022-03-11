part of 'it_bloc.dart';

enum ItStatus { initial, success, failure }

class ItState extends Equatable {
  const ItState({
    this.status = ItStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final ItStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  ItState copyWith({
    ItStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return ItState(
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
