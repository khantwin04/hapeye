part of 'business_bloc.dart';

enum BusinessStatus { initial, success, failure }

class BusinessState extends Equatable {
  const BusinessState({
    this.status = BusinessStatus.initial,
    this.postList = const <PostModel>[],
    this.hasReachedMax = false,
  });

  final BusinessStatus status;
  final List<PostModel> postList;
  final bool hasReachedMax;

  BusinessState copyWith({
    BusinessStatus? status,
    List<PostModel>? postList,
    bool? hasReachedMax,
  }) {
    return BusinessState(
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
