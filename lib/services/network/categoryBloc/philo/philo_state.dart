part of 'philo_bloc.dart';

enum PhiloStatus { initial, success, failure }

class PhiloState extends Equatable {
  const PhiloState({
    this.status = PhiloStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final PhiloStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  PhiloState copyWith({
    PhiloStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return PhiloState(
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
